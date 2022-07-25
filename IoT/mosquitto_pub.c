#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <mosquitto.h>
#include <stdio.h>
#include <unistd.h>

#define MQTT_HOSTNAME "localhost"
#define MQTT_PORT 1883
#define MQTT_CLIENTID "erts_post"
#define MQTT_TOPIC "hello"

char text[100] = "Hello World";
static int mid_sent = 0;
static int qos = 0;
static int retain = 0;

void my_disconnect_callback(struct mosquitto *mosq, void *obj, int rc)
{
    printf("Disconnected!\n");
}

void my_publish_callback(struct mosquitto *mosq, void *obj, int mid)
{
    printf("Published!\n");
}

int main(int argc, char *argv[])
{
    struct mosquitto *mosq = NULL;

    mosquitto_lib_init();
    mosq = mosquitto_new(MQTT_CLIENTID, true, NULL);
    if (!mosq)
    {
        printf("Cant initiallize mosquitto library\n");
        exit(-1);
    }
    mosquitto_disconnect_callback_set(mosq, my_disconnect_callback);
    mosquitto_publish_callback_set(mosq, my_publish_callback);
    int rc = mosquitto_connect(mosq, MQTT_HOSTNAME, MQTT_PORT, 60);
    if (rc != 0)
    {
        printf("Client could not connect to broker! Error Code: %d\n", rc);
        mosquitto_destroy(mosq);
        exit(0);
    }
    printf("We are now connected to the broker!\n");

    mosquitto_publish(mosq, &mid_sent, MQTT_TOPIC, strlen(text), text, qos, retain);
    /*
        QoS 0: when we prefer that the message will arrive at most once; the message will be received or it won't, there isn't a chance of a duplicate; at most once; fire and forget;
        QoS 1: when we want the message to arrive at least once but don’t care if it arrives twice (or more); at least once;
        QoS 2: when we want the message to arrive exactly once. A higher QOS value means a slower transfer; exactly once.
    */
    printf("we published with mid: %d\n", mid_sent);

    mosquitto_destroy(mosq);
    mosquitto_lib_cleanup();

    return 0;
}