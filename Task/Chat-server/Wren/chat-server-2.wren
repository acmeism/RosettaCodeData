/* gcc Chat_server.c -o Chat_server -lpthread -lwren -lm */

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <pthread.h>
#include <sys/types.h>
#include <signal.h>
#include <wren.h>

#define MAX_CLIENTS 10
#define BUFFER_SZ 2048

static _Atomic unsigned int cli_count = 0;
static int listenfd = 0, uid = 10;
char *script = NULL;

/* Client structure */
typedef struct {
    struct sockaddr_in addr; /* Client remote address */
    int connfd;              /* Connection file descriptor */
    int uid;                 /* Client unique identifier */
    int vmi;                 /* The index of the VM which handles this client */
    char name[32];           /* Client name */
} client_t;

client_t *clients[MAX_CLIENTS];

pthread_mutex_t clients_mutex = PTHREAD_MUTEX_INITIALIZER;

static char topic[BUFFER_SZ/2];

pthread_mutex_t topic_mutex = PTHREAD_MUTEX_INITIALIZER;

WrenVM* vms[MAX_CLIENTS]; // array of VMs

/* add client to queue */
void queue_add(client_t *cl){
    pthread_mutex_lock(&clients_mutex);
    for (int i = 0; i < MAX_CLIENTS; ++i) {
        if (!clients[i]) {
            cl->vmi = i;
            clients[i] = cl;
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

/* Delete client from queue */
void queue_delete(int uid){
    pthread_mutex_lock(&clients_mutex);
    for (int i = 0; i < MAX_CLIENTS; ++i) {
        if (clients[i]) {
            if (clients[i]->uid == uid) {
                clients[i] = NULL;
                break;
            }
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

/* print ip address */
void print_client_addr(struct sockaddr_in addr){
    printf("%d.%d.%d.%d",
        addr.sin_addr.s_addr & 0xff,
        (addr.sin_addr.s_addr & 0xff00) >> 8,
        (addr.sin_addr.s_addr & 0xff0000) >> 16,
        (addr.sin_addr.s_addr & 0xff000000) >> 24);
}

/* enable Wren to handle all client communication */
void *handle_client(void *arg) {
    client_t *cli = (client_t *)arg;
    cli_count++;
    int vmi = cli->vmi;
    WrenHandle *callHandle = wrenMakeCallHandle(vms[vmi], "handleClient(_)");
    wrenEnsureSlots(vms[vmi], 2);
    wrenGetVariable(vms[vmi], "main", "Chat", 0);
    wrenSetSlotDouble(vms[vmi], 1, (double)vmi);
    wrenCall(vms[vmi], callHandle);
}

/* C <= Wren interface functions */

void C_max(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, (double)MAX_CLIENTS);
}

void C_count(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, (double)cli_count);
}

void C_isActive(WrenVM* vm) {
    int vmi = (int)wrenGetSlotDouble(vm, 1);
    bool res = clients[vmi] != NULL;
    wrenSetSlotBool(vm, 0, res);
}

void C_connfd(WrenVM* vm) {
    int vmi = (int)wrenGetSlotDouble(vm, 1);
    wrenSetSlotDouble(vm, 0, (double)clients[vmi]->connfd);
}

void C_uid(WrenVM* vm) {
    int vmi = (int)wrenGetSlotDouble(vm, 1);
    wrenSetSlotDouble(vm, 0, (double)clients[vmi]->uid);
}

void C_name(WrenVM* vm) {
    int vmi = (int)wrenGetSlotDouble(vm, 1);
    wrenSetSlotString(vm, 0, (const char *)clients[vmi]->name);
}

void C_setName(WrenVM* vm) {
    int vmi = (int)wrenGetSlotDouble(vm, 1);
    const char *name = wrenGetSlotString(vm, 2);
    size_t size = sizeof(clients[vmi]->name);
    strncpy(clients[vmi]->name, name, size);
    clients[vmi]->name[size-1] = '\0';
}

void C_clientsLock(WrenVM* vm) {
    pthread_mutex_lock(&clients_mutex);
}

void C_clientsUnlock(WrenVM* vm) {
    pthread_mutex_unlock(&clients_mutex);
}

void C_topicLock(WrenVM* vm) {
    pthread_mutex_lock(&topic_mutex);
}

void C_topicUnlock(WrenVM* vm) {
    pthread_mutex_unlock(&topic_mutex);
}

void C_printAddr(WrenVM* vm) {
    int vmi = (int)wrenGetSlotDouble(vm, 1);
    print_client_addr(clients[vmi]->addr);
}

void C_topic(WrenVM* vm) {
    wrenSetSlotString(vm, 0, (const char *)topic);
}

void C_setTopic(WrenVM* vm) {
    const char *t = wrenGetSlotString(vm, 1);
    strncpy(topic, t, sizeof(topic));
    topic[sizeof(topic)-1] = '\0';
}

void C_bufferSize(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, (double)BUFFER_SZ);
}

void C_write(WrenVM* vm) {
    int fd = (int)wrenGetSlotDouble(vm, 1);
    const void *buf = (const void *)wrenGetSlotString(vm, 2);
    size_t count = (size_t)wrenGetSlotDouble(vm, 3);
    ssize_t res = write(fd, buf, count);
    wrenSetSlotDouble(vm, 0, (double)res);
}

void C_read(WrenVM* vm) {
    char buf[BUFFER_SZ / 2];
    int fd = (int)wrenGetSlotDouble(vm, 1);
    size_t count = (size_t)wrenGetSlotDouble(vm, 2);
    ssize_t rlen = read(fd, buf, count);
    buf[rlen] = '\0';
    wrenSetSlotString(vm, 0, (const char *)buf);
}

void C_close(WrenVM* vm) {
    int connfd = (int)wrenGetSlotDouble(vm, 1);
    close(connfd);
}

void C_delete(WrenVM* vm) {
    int vmi = (int)wrenGetSlotDouble(vm, 1);
    client_t *cli = clients[vmi];
    queue_delete(cli->uid);
    free(cli);
    cli_count--;
    pthread_detach(pthread_self());
}

WrenForeignMethodFn bindForeignMethod(
    WrenVM* vm,
    const char* module,
    const char* className,
    bool isStatic,
    const char* signature) {
    if (strcmp(module, "main") == 0) {
        if (strcmp(className, "Clients") == 0) {
            if (isStatic && strcmp(signature, "max") == 0)             return C_max;
            if (isStatic && strcmp(signature, "count") == 0)           return C_count;
            if (isStatic && strcmp(signature, "isActive(_)") == 0)     return C_isActive;
            if (isStatic && strcmp(signature, "connfd(_)") == 0)       return C_connfd;
            if (isStatic && strcmp(signature, "uid(_)") == 0)          return C_uid;
            if (isStatic && strcmp(signature, "name(_)") == 0)         return C_name;
            if (isStatic && strcmp(signature, "setName(_,_)") == 0)    return C_setName;
            if (isStatic && strcmp(signature, "printAddr(_)") == 0)    return C_printAddr;
            if (isStatic && strcmp(signature, "delete(_)") == 0)       return C_delete;
        } else if (strcmp(className, "Mutex") == 0) {
            if (isStatic && strcmp(signature, "clientsLock()") == 0)   return C_clientsLock;
            if (isStatic && strcmp(signature, "clientsUnlock()") == 0) return C_clientsUnlock;
            if (isStatic && strcmp(signature, "topicLock()") == 0)     return C_topicLock;
            if (isStatic && strcmp(signature, "topicUnlock()") == 0)   return C_topicUnlock;
        } else if (strcmp(className, "Chat") == 0) {
            if (isStatic && strcmp(signature, "topic") == 0)           return C_topic;
            if (isStatic && strcmp(signature, "topic=(_)") == 0)       return C_setTopic;
            if (isStatic && strcmp(signature, "bufferSize") == 0)      return C_bufferSize;
            if (isStatic && strcmp(signature, "write(_,_,_)") == 0)    return C_write;
            if (isStatic && strcmp(signature, "read(_,_)") == 0)       return C_read;
            if (isStatic && strcmp(signature, "close(_)") == 0)        return C_close;
        }
    }
    return NULL;
}

static void writeFn(WrenVM* vm, const char* text) {
    printf("%s", text);
}

void errorFn(WrenVM* vm, WrenErrorType errorType, const char* module, const int line, const char* msg) {
    switch (errorType) {
        case WREN_ERROR_COMPILE:
            printf("[%s line %d] [Error] %s\n", module, line, msg);
            break;
        case WREN_ERROR_STACK_TRACE:
            printf("[%s line %d] in %s\n", module, line, msg);
            break;
        case WREN_ERROR_RUNTIME:
            printf("[Runtime Error] %s\n", msg);
            break;
    }
}

char *readFile(const char *fileName) {
    FILE *f = fopen(fileName, "r");
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    rewind(f);
    char *script = malloc(fsize + 1);
    fread(script, 1, fsize, f);
    fclose(f);
    script[fsize] = 0;
    return script;
}

void catch_ctrl_c(int sig) {
    /* clean up and exit */
    for (int i = 0; i < MAX_CLIENTS; ++i) {
        wrenFreeVM(vms[i]);
        if (clients[i]) {
            close(clients[i]->connfd);
            free(clients[i]);
        }
    }
    close(listenfd);
    free(script);
    printf("\n<[ SERVER ENDED ]>\n");
    exit(EXIT_SUCCESS);
}

int main(int argc, char **argv) {
    WrenConfiguration config;
    wrenInitConfiguration(&config);
    config.writeFn = &writeFn;
    config.errorFn = &errorFn;
    config.bindForeignMethodFn = &bindForeignMethod;
    const char* module = "main";
    const char* fileName = "Chat_server.wren";
    script = readFile(fileName);

    /* config the VMs and interpret the script */
    for (int i = 0; i < MAX_CLIENTS; ++i) {
        vms[i] = wrenNewVM(&config);
        wrenInterpret(vms[i], module, script);
    }

    /* prepare to start the server */
    int connfd = 0;
    struct sockaddr_in serv_addr;
    struct sockaddr_in cli_addr;
    pthread_t tid;

    /* socket settings */
    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(5000);

    /* ignore pipe signals */
    signal(SIGPIPE, SIG_IGN);

    /* catch ctrl-c being pressed */
    signal(SIGINT, catch_ctrl_c);

    /* bind */
    if (bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Socket binding failed");
        return EXIT_FAILURE;
    }

    /* listen */
    if (listen(listenfd, 10) < 0) {
        perror("Socket listening failed");
        return EXIT_FAILURE;
    }

    printf("<[ SERVER STARTED ]>\n");

    /* accept clients */
    while (1) {
        socklen_t clilen = sizeof(cli_addr);
        connfd = accept(listenfd, (struct sockaddr*)&cli_addr, &clilen);

        /* check if max clients is reached */
        if ((cli_count + 1) == MAX_CLIENTS) {
            printf("<< max clients reached\n");
            printf("<< reject ");
            print_client_addr(cli_addr);
            printf("\n");
            close(connfd);
            continue;
        }

        /* client settings */
        client_t *cli = (client_t *)malloc(sizeof(client_t));
        cli->addr = cli_addr;
        cli->connfd = connfd;
        cli->uid = uid++;
        sprintf(cli->name, "%d", cli->uid);

        /* add client to the queue and fork thread */
        queue_add(cli);
        pthread_create(&tid, NULL, &handle_client, (void*)cli);

        /* reduce CPU usage */
        sleep(1);
    }

    return 0;
}
