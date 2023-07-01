#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

/* The language task, implemented with pthreads for POSIX systems. */

/* Each rendezvous_t will be accepted by a single thread, and entered
 * by one or more threads.  accept_func() only returns an integer and
 * is always run within the entering thread's context to simplify
 * handling the arguments and return value.  This somewhat unlike an
 * Ada rendezvous and is a subset of the Ada rendezvous functionality.
 * Ada's in and out parameters can be simulated via the void pointer
 * passed to accept_func() to update variables owned by both the
 * entering and accepting threads, if a suitable struct with pointers
 * to those variables is used. */
typedef struct rendezvous {
    pthread_mutex_t lock;        /* A mutex/lock to use with the CVs.        */
    pthread_cond_t cv_entering;  /* Signaled when a thread enters.           */
    pthread_cond_t cv_accepting; /* Signaled when accepting thread is ready. */
    pthread_cond_t cv_done;      /* Signaled when accept_func() finishes.    */
    int (*accept_func)(void*);   /* The function to run when accepted.       */
    int entering;                /* Number of threads trying to enter.       */
    int accepting;               /* True if the accepting thread is ready.   */
    int done;                    /* True if accept_func() is done.           */
} rendezvous_t;

/* Static initialization for rendezvous_t. */
#define RENDEZVOUS_INITILIZER(accept_function) {   \
        .lock         = PTHREAD_MUTEX_INITIALIZER, \
        .cv_entering  = PTHREAD_COND_INITIALIZER,  \
        .cv_accepting = PTHREAD_COND_INITIALIZER,  \
        .cv_done      = PTHREAD_COND_INITIALIZER,  \
        .accept_func  = accept_function,           \
        .entering     = 0,                         \
        .accepting    = 0,                         \
        .done         = 0,                         \
    }

int enter_rendezvous(rendezvous_t *rv, void* data)
{
    /* Arguments are passed in and out of the rendezvous via
     * (void*)data, and the accept_func() return value is copied and
     * returned to the caller (entering thread).  A data struct with
     * pointers to variables in both the entering and accepting
     * threads can be used to simulate Ada's in and out parameters, if
     * needed. */
    pthread_mutex_lock(&rv->lock);

    rv->entering++;
    pthread_cond_signal(&rv->cv_entering);

    while (!rv->accepting) {
        /* Nothing is accepting yet, keep waiting.  pthreads will
         * queue all waiting entries.  The loop is needed to handle
         * both race conditions and spurious wakeups. */
        pthread_cond_wait(&rv->cv_accepting, &rv->lock);
    }

    /* Call accept_func() and copy the return value before leaving
     * the mutex. */
    int ret = rv->accept_func(data);

    /* This signal is needed so that the accepting thread will wait
     * for the rendezvous to finish before trying to accept again. */
    rv->done = 1;
    pthread_cond_signal(&rv->cv_done);

    rv->entering--;
    rv->accepting = 0;
    pthread_mutex_unlock(&rv->lock);

    return ret;
}

void accept_rendezvous(rendezvous_t *rv)
{
    /* This accept function does not take in or return parameters.
     * That is handled on the entry side.  This is only for
     * synchronization. */
    pthread_mutex_lock(&rv->lock);
    rv->accepting = 1;

    while (!rv->entering) {
        /* Nothing to accept yet, keep waiting. */
        pthread_cond_wait(&rv->cv_entering, &rv->lock);
    }

    pthread_cond_signal(&rv->cv_accepting);

    while (!rv->done) {
        /* Wait for accept_func() to finish. */
        pthread_cond_wait(&rv->cv_done, &rv->lock);
    }
    rv->done = 0;

    rv->accepting = 0;
    pthread_mutex_unlock(&rv->lock);
}

/* The printer use case task implemented using the above rendezvous
 * implementation.  Since C doesn't have exceptions, return values are
 * used to signal out of ink errors. */

typedef struct printer {
    rendezvous_t rv;
    struct printer *backup;
    int id;
    int remaining_lines;
} printer_t;

typedef struct print_args {
    struct printer *printer;
    const char* line;
} print_args_t;

int print_line(printer_t *printer, const char* line) {
    print_args_t args;
    args.printer = printer;
    args.line = line;
    return enter_rendezvous(&printer->rv, &args);
}

int accept_print(void* data) {
    /* This is called within the rendezvous, so everything is locked
     * and okay to modify. */
    print_args_t *args = (print_args_t*)data;
    printer_t *printer = args->printer;
    const char* line = args->line;

    if (printer->remaining_lines) {
        /* Print the line, character by character. */
        printf("%d: ", printer->id);
        while (*line != '\0') {
            putchar(*line++);
        }
        putchar('\n');
        printer->remaining_lines--;
        return 1;
    }
    else if (printer->backup) {
        /* "Requeue" this rendezvous with the backup printer. */
        return print_line(printer->backup, line);
    }
    else {
        /* Out of ink, and no backup available. */
        return -1;
    }
}

printer_t backup_printer = {
    .rv = RENDEZVOUS_INITILIZER(accept_print),
    .backup = NULL,
    .id = 2,
    .remaining_lines = 5,
};

printer_t main_printer = {
    .rv = RENDEZVOUS_INITILIZER(accept_print),
    .backup = &backup_printer,
    .id = 1,
    .remaining_lines = 5,
};

void* printer_thread(void* thread_data) {
    printer_t *printer = (printer_t*) thread_data;
    while (1) {
        accept_rendezvous(&printer->rv);
    }
}

typedef struct poem {
    char* name;
    char* lines[];
} poem_t;

poem_t humpty_dumpty = {
    .name = "Humpty Dumpty",
    .lines = {
        "Humpty Dumpty sat on a wall.",
        "Humpty Dumpty had a great fall.",
        "All the king's horses and all the king's men",
        "Couldn't put Humpty together again.",
        ""
    },
};

poem_t mother_goose = {
    .name = "Mother Goose",
    .lines = {
        "Old Mother Goose",
        "When she wanted to wander,",
        "Would ride through the air",
        "On a very fine gander.",
        "Jack's mother came in,",
        "And caught the goose soon,",
        "And mounting its back,",
        "Flew up to the moon.",
        ""
    },
};

void* poem_thread(void* thread_data) {
    poem_t *poem = (poem_t*)thread_data;

    for (unsigned i = 0; poem->lines[i] != ""; i++) {
        int ret = print_line(&main_printer, poem->lines[i]);
        if (ret < 0) {
            printf("      %s out of ink!\n", poem->name);
            exit(1);
        }
    }
    return NULL;
}

int main(void)
{
    pthread_t threads[4];

    pthread_create(&threads[0], NULL, poem_thread,    &humpty_dumpty);
    pthread_create(&threads[1], NULL, poem_thread,    &mother_goose);
    pthread_create(&threads[2], NULL, printer_thread, &main_printer);
    pthread_create(&threads[3], NULL, printer_thread, &backup_printer);

    pthread_join(threads[0], NULL);
    pthread_join(threads[1], NULL);
    pthread_cancel(threads[2]);
    pthread_cancel(threads[3]);

    return 0;
}
