#include <stdio.h>
#include <mosquitto.h>

#define MQTT_HOSTNAME "localhost"
#define MQTT_PORT 1883
#define MQTT_CLIENTID "erts_sub"
#define MQTT_TOPIC "hello"

void my_message_callback(struct mosquitto *mosq, void *userdata, const struct mosquitto_message *message)
{
    if (message->payloadlen)
    {
        printf("%s %s\n", message->topic, message->payload);
    }
    else
    {
        printf("%s (null)\n", message->topic);
    }
    fflush(stdout);
}

void my_connect_callback(struct mosquitto *mosq, void *userdata, int result)
{
    int i;
    if (!result)
    {
        /* Subscribe to broker information topics on successful connect. */
        mosquitto_subscribe(mosq, NULL, "hello", 2);
    }
    else
    {
        printf("Connect failed\n");
    }
}

void my_subscribe_callback(struct mosquitto *mosq, void *userdata, int mid, int qos_count, const int *granted_qos)
{
    int i;

    printf("Subscribed (mid: %d): %d", mid, granted_qos[0]);
    for (i = 1; i < qos_count; i++)
    {
        printf(", %d", granted_qos[i]);
    }
    printf("\n");
}

int main(int argc, char *argv[])
{
    int i;
    struct mosquitto *mosq = NULL;

    mosquitto_lib_init();
    mosq = mosquitto_new(NULL, true, NULL);
    // 1st arg: id
    // 2nd arg: clean_session
    // 3rd arg: userData
    if (!mosq)
    {
        printf("Error: Out of memory.\n");
        return 1;
    }
    mosquitto_connect_callback_set(mosq, my_connect_callback);
    mosquitto_message_callback_set(mosq, my_message_callback);
    mosquitto_subscribe_callback_set(mosq, my_subscribe_callback);

    if (mosquitto_connect(mosq, MQTT_HOSTNAME, MQTT_PORT, 60))
    // keepalive=60
    {
        printf("Unable to connect.\n");
        return 1;
    }

    mosquitto_loop_forever(mosq, -1, 1);
    //2nd arg: timeout
    //3rd: max_packets

    mosquitto_destroy(mosq);
    mosquitto_lib_cleanup();
    return 0;
}