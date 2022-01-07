pragma solidity ^0.8.0;

contract Messaging {

    uint256 public messageCount = 0;
    mapping(uint256 => Message) public messages;
    mapping(address => uint256[]) public receiverToMessages;

    struct Message {
        uint256 msg_id;
        address sender;
        address receiver;
        ThreadElem[] thread;
        uint256 timestamp;
    }

    struct ThreadElem {
        string receiver_key;
        string receiver_uri;
        string sender_key;
        string sender_uri;
    }

    event MessageSent(
        uint256 msg_id,
        address receiver,
        string uri,
        string encrypted_key,
        uint256 timestamp
    );

    event Replied(
        uint256 msg_id,
        address receiver,
        string uri,
        string encrypted_key,
        uint256 timestamp
    );

    function sendMessage(
        string memory _uri,
        string memory receiver_key,
        string memory receiver_uri,
        string memory sender_key,
        string memory sender_uri,
        address _receiver
    ) public {
        messageCount++;

        ThreadElem memory _threadElem = ThreadElem(
            receiver_key,
            receiver_uri,
            sender_key,
            sender_uri
        );

        ThreadElem[] memory thread;

        thread[0] = _threadElem;

        messages[messageCount] = Message(
            messageCount,
            msg.sender,
            _receiver,
            thread,
            block.timestamp
        );

        receiverToMessages[_receiver].push(messageCount);

        emit MessageSent(messageCount, _receiver, _uri, receiver_key, block.timestamp);
    }

    function reply(
        uint256 _msg_id,
        string memory _receiver_uri,
        string memory _receiver_key,
        string memory _sender_uri,
        string memory _sender_key
    ) public {
        Message memory message = messages[_msg_id];

        require(msg.sender == message.receiver || msg.sender == message.sender, "Only the receiver & sender can reply to the messages.");

        ThreadElem memory _threadElem = ThreadElem(
            _receiver_key,
            _receiver_uri,
            _sender_key,
            _sender_uri
        );

        message.thread[message.thread.length + 1] = _threadElem;

        emit Replied(_msg_id, message.sender, _receiver_uri, _receiver_key, block.timestamp);
    }

    function allMessages(address _receiver) external view returns (Message[] memory) {
        Message[] memory list = new Message[](receiverToMessages[_receiver].length);

        for(uint256 i = 0; i < receiverToMessages[_receiver].length; i++) {
            list[i] = messages[receiverToMessages[_receiver][i]];
        }

        return list;
    }
}