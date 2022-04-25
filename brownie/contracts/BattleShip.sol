//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

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
        mapping(address => uint8[]) shotsHistory;
    }

    enum State {
        Initial,
        Started,
        Finished,
        Winner
    }
    State public state;
    mapping (address => uint256[]) shotsPlayer;


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
    uint immutable revealProgramHash = 0x42ca59a92b355e482d343627aa76d02aa1569e6d63db020e5613aa7d509acab;
    
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
                require(shot is not in Player.shtots)
        positionShot[i][]
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


    function verifyCombatOutputPlayerAShot(uint256[] memory programOutput) public {
    bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
    bytes32 fact = keccak256(abi.encodePacked(revealProgramHash, outputHash));
    require(cairoVerifier_.isValid(fact), "MISSING_CAIRO_PROOF");

    // Ensure the output consistency with current system state.
    require(programOutput.length == 4, "INVALID_PROGRAM_OUTPUT");
    require(playerB.shifterHash == programOutput[0], "INVALID_PROGRAM_OUTPUT 0");
    require(playerB.shipHashLocation == programOutput[1], "INVALID_PROGRAM_OUTPUT 1");
    }

    function verifyCombatOutputPlayerBShot(uint256[] memory programOutput) public {
    bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
    bytes32 fact = keccak256(abi.encodePacked(revealProgramHash, outputHash));
    require(cairoVerifier_.isValid(fact), "MISSING_CAIRO_PROOF");

    // Ensure the output consistency with current system state.
    require(programOutput.length == 4, "INVALID_PROGRAM_OUTPUT");
    require(playerA.shifterHash == programOutput[0], "INVALID_PROGRAM_OUTPUT 0");
    require(playerA.shipHashLocation == programOutput[1], "INVALID_PROGRAM_OUTPUT 1");

    }
}

