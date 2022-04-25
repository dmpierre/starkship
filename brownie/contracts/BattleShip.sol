//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IFactRegistry {
    /*
      Returns true if the given fact was previously registered in the contract.
    */
    function isValid(bytes32 fact)
        external view
        returns(bool);
}

contract starkShip {
    Player[2] players;
    address[] playerAddresses;
    uint256 public counter;
    uint8 public currentPlayer;
    uint8 public numOfPlayers;
    uint256 shifter;
    uint256 locShip;
    uint256 programhash;

    struct Player {
        address addr;
        uint256 shipPosition;
        uint256 shifter;
        bool turn;
    }

    enum State {
        Initial,
        Started,
        Finished,
        Winner
    }
    State public state;

    constructor(
        uint256 shipHashLocation,
        uint256 shifterHash,
        uint256 programhash
    ) {
        Player memory playerA = Player(
            msg.sender,
            shipHashLocation,
            shifterHash,
            false
        );
        players[0] = playerA;
        programhash = programhash;
        state = State.Initial;
    }
    
    address public verifierContract = 0xAB43bA48c9edF4C2C4bB01237348D1D7B28ef168;
    
    IFactRegistry public verifier = IFactRegistry(verifierContract);

    function playerJoins(
        address _addr,
        uint256 shipHashLocation,
        uint256 shifterHash,
        bool _turn
    ) public {
        require(state == State.Initial);
        Player memory playerB = Player(
            msg.sender,
            shipHashLocation,
            shifterHash,
            true
        );
        players[1] = playerB;
        state = State.Started;
    } 

    mapping(address => uint256[]) shotsPlayer; //Holds the shots of a specific player ;
    mapping(uint256 => mapping(address => uint8[])) positionShot; // Holds the position of the shot in the grid for a player for a current turn.

    //mapping (uint => mapping(address => uint8)) lastPositionShot; //Holds the index of the last fired position.
    //mapping (uint => mapping(address => ShipPosition[])) correctPositionsHit;   //Position of the correct position -> winner

    function makeShot(address _player, uint256 _shot)
        public
        view
        returns (uint256[] memory)
    {
        require(state == State.Started);
        return shotsPlayer[_player];
    }

    //Get new grid based on the last shot mapping
    function updateGrid() public view returns (uint8) {}

    //position of the last attacked position

    function getLastPositionAttacked(address _player, uint256 _counter){
        public
        view
        returns (uint8)
    }
    
}
