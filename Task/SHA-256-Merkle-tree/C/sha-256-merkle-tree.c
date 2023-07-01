#include <glib.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

guchar* sha256_merkle_tree(FILE* in, size_t block_size) {
    gchar* buffer = g_malloc(block_size);
    GPtrArray* hashes = g_ptr_array_new_with_free_func(g_free);
    gssize digest_length = g_checksum_type_get_length(G_CHECKSUM_SHA256);
    GChecksum* checksum = g_checksum_new(G_CHECKSUM_SHA256);
    size_t bytes;
    while ((bytes = fread(buffer, 1, block_size, in)) > 0) {
        g_checksum_reset(checksum);
        g_checksum_update(checksum, (guchar*)buffer, bytes);
        gsize len = digest_length;
        guchar* digest = g_malloc(len);
        g_checksum_get_digest(checksum, digest, &len);
        g_ptr_array_add(hashes, digest);
    }
    g_free(buffer);
    guint hashes_length = hashes->len;
    if (hashes_length == 0) {
        g_ptr_array_free(hashes, TRUE);
        g_checksum_free(checksum);
        return NULL;
    }
    while (hashes_length > 1) {
        guint j = 0;
        for (guint i = 0; i < hashes_length; i += 2, ++j) {
            guchar* digest1 = g_ptr_array_index(hashes, i);
            guchar* digest_out = g_ptr_array_index(hashes, j);
            if (i + 1 < hashes_length) {
                guchar* digest2 = g_ptr_array_index(hashes, i + 1);
                g_checksum_reset(checksum);
                g_checksum_update(checksum, digest1, digest_length);
                g_checksum_update(checksum, digest2, digest_length);
                gsize len = digest_length;
                g_checksum_get_digest(checksum, digest_out, &len);
            } else {
                memcpy(digest_out, digest1, digest_length);
            }
        }
        hashes_length = j;
    }
    guchar* result = g_ptr_array_steal_index(hashes, 0);
    g_ptr_array_free(hashes, TRUE);
    g_checksum_free(checksum);
    return result;
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "usage: %s filename\n", argv[0]);
        return EXIT_FAILURE;
    }
    FILE* in = fopen(argv[1], "rb");
    if (in) {
        guchar* digest = sha256_merkle_tree(in, 1024);
        fclose(in);
        if (digest) {
            gssize length = g_checksum_type_get_length(G_CHECKSUM_SHA256);
            for (gssize i = 0; i < length; ++i)
                printf("%02x", digest[i]);
            printf("\n");
            g_free(digest);
        }
    } else {
        perror(argv[1]);
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
