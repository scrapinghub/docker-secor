package com.pinterest.secor.transformer;

import com.pinterest.secor.common.SecorConfig;
import com.pinterest.secor.message.Message;

import net.minidev.json.JSONObject;
import net.minidev.json.JSONValue;

/**
 * Message transformer class which uses "message" field of a JSON message
 * payload and uses it as a payload instead.
 */
public class JsonMessageTransformer extends IdentityMessageTransformer {

    public JsonMessageTransformer(SecorConfig config) {
        super(config);
    }

    @Override
    public Message transform(Message message) {
        JSONObject jsonObject = (JSONObject) JSONValue.parse(
            message.getPayload()
        );
        String messageJsonString = (String) jsonObject.get("message");
        byte[] payload = messageJsonString.getBytes();
        return new Message(
            message.getTopic(),
            message.getKafkaPartition(),
            message.getOffset(),
            message.getKafkaKey(),
            payload,
            message.getTimestamp()
        );
    }

}