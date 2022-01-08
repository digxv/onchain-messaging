pragma solidity ^0.8.0;

contract Messaging {

    uint256 public threadCount = 1;
    mapping(uint256 => Thread) public threads;

    struct Thread {
        uint256 thread_id;
        address receiver;
        string receiver_key;
        address sender;
        string sender_key;
        Message[] messages;
    }

    struct Message {
        address receiver;
        string uri;
        uint256 timestamp;
    }

    function newThread(
        address _receiver,
        string memory _sender_key,
        string memory _receiver_key
    ) public returns (uint256) {
        threadCount++;

        Message[] memory messages;

        threads[threadCount] = Thread(
            threadCount,
            _receiver,
            _receiver_key,
            msg.sender,
            _sender_key,
            messages
        );

        return threadCount;
    }

    function sendMessage(
        uint256 _thread_id,
        string memory _uri,
        address _receiver,
        string memory _sender_key,
        string memory _receiver_key
    ) public {
        if (_thread_id == 0) {
            uint256 new_thread_id = newThread(
                _receiver,
                _sender_key,
                _receiver_key
            );

            Thread memory thread = threads[new_thread_id];

            Message[] memory messages;

            messages[messages.length] = Message(
                _receiver,
                _uri,
                block.timestamp
            );

            thread.messages = messages;
        } else {
            Thread memory thread = threads[_thread_id];

            require(msg.sender == thread.receiver || msg.sender == thread.sender, "Only the receiver & sender can reply to the messages.");

            Message memory message = Message(
                _receiver,
                _uri,
                block.timestamp
            );

            // ERROR HERE PLS
            thread.messages.push(message);
        }
    }
}