//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

// import "./DateTime.sol";

contract eventOrganizer {
    struct Event {
        address organizer;
        string name;
        uint256 date;
        uint256 ticketCount;
        uint256 ticketRemain;
        uint256 price;
        string place;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextId;

    // function convertTimestampToDate(uint256 timestamp) private  view returns (uint16 year, uint8 month, uint8 day) {
    //     return DateTime.toLocalTime(timestamp);
    // }

    function createEvent(
        string memory name,
        uint256 date,
        uint256 ticketCount,
        uint256 price,
        string memory place
    ) external {
        require(date > block.timestamp, "Date is in the past ");
        require(ticketCount > 0, "No. of tickets must be more than 0");

        require(price >= 0, "Price must be Greater then 0");

        //  Event[date] =convertTimestampToDate();

        events[nextId] = Event(
            msg.sender,
            name,
            date,
            ticketCount,
            ticketCount,
            price,
            place
        );
        nextId++;
    }

    function buyTickets(uint256 id, uint256 quantity) external payable {
        require(events[id].date != 0, "Invalid event Id"); // Check if the event Id is valid
        require(events[id].date > block.timestamp, "Event is over");
        //   require (msg.value  == events[id].price*quantity,"funds insuffient");
        Event storage _event = events[id];
        require(msg.value == (_event.price * quantity), "funds insuffient");
        require(_event.ticketRemain >= quantity, "tickets are not available");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTickets(
        uint256 eventId,
        uint256 quantity,
        address to
    ) external {
        require(events[eventId].date != 0, "Invalid event ID");
        require(events[eventId].date > block.timestamp, "Event is over");
        require(
            tickets[msg.sender][eventId] >= quantity,
            "Insufficient tickets"
        ); // jite ticket bej rha uute ticket khud k pass hone chaiye

        tickets[msg.sender][eventId] -= quantity;
        tickets[to][eventId] += quantity;
    }

// function getUserTickets(address user, uint256 eventId) external view returns (uint256) {
//     return tickets[user][eventId];
// }

function getUserTickets(address user) external view returns (uint256[] memory, uint256[] memory) {
    uint256[] memory eventIds = new uint256[](nextId);
    uint256[] memory ticketQuantities = new uint256[](nextId);

    for (uint256 i = 0; i < nextId; i++) {
        eventIds[i] = i;
        ticketQuantities[i] = tickets[user][i];
    }

    return (eventIds, ticketQuantities);
}



}
