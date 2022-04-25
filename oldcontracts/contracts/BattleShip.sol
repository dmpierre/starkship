//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

interface IFactRegistry {
    /*
      Returns true if the given fact was previously registered in the contract.
    */
    function isValid(bytes32 fact) external view returns (bool);
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
        uint256 shipHashLocation;
        uint256 shifterHash;
    }

    enum State {
        Initial,
        Started,
        Winner
    }
    State public state;

    mapping(address => bool[64]) shotsPlayer;
    address public verifierContract =
        0xAB43bA48c9edF4C2C4bB01237348D1D7B28ef168;
    uint256 immutable revealProgramHash =
        0x42ca59a92b355e482d343627aa76d02aa1569e6d63db020e5613aa7d509acab;
    uint256 turn;

    constructor(uint256 shipHashLocation, uint256 shifterHash) {
        Player memory playerA = Player(
            msg.sender,
            shipHashLocation,
            shifterHash
        );
        players[0] = playerA;
        state = State.Initial;
    }

    IFactRegistry public verifier = IFactRegistry(verifierContract);

    function playerJoins(uint256 shipHashLocation, uint256 shifterHash) public {
        require(state == State.Initial);
        Player memory playerB = Player(
            msg.sender,
            shipHashLocation,
            shifterHash
        );
        players[1] = playerB;
        state = State.Started;
        turn = 1;
    }

    function makeShot(uint256[] memory programOutput) public {
        require(programOutput[3] < 64);
        require(state == State.Started);
        require(players[turn].addr == msg.sender);
        require(shotsPlayer[msg.sender][programOutput[3]] == false);
        verifyCombatOutputPlayerAShot(programOutput);
        shotsPlayer[msg.sender][programOutput[3]] = true;
        if (programOutput[2] == 1) {
            state = State.Winner;
            return ();
        }
        if (turn == 1) {
            turn = 0;
        } else {
            turn = 1;
        }
        return ();
    }

    //Get new grid based on the last shot mapping
    function updateGrid() public view returns (uint8) {}

    //position of the last attacked position

    // function getLastPositionAttacked(address _player, uint256 _counter){
    //     public
    //     view
    //     returns (uint8)
    // }

    function verifyCombatOutputPlayerAShot(uint256[] memory programOutput)
        public
    {
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(
            abi.encodePacked(revealProgramHash, outputHash)
        );
        require(
            IFactRegistry(verifierContract).isValid(fact),
            "MISSING_CAIRO_PROOF"
        );

        // Ensure the output consistency with current system state.
        if (turn == 1) {
            require(programOutput.length == 4, "INVALID_PROGRAM_OUTPUT");
            require(
                players[0].shifterHash == programOutput[0],
                "INVALID_PROGRAM_OUTPUT 0"
            );
            require(
                players[0].shipHashLocation == programOutput[1],
                "INVALID_PROGRAM_OUTPUT 1"
            );
        } else {
            require(programOutput.length == 4, "INVALID_PROGRAM_OUTPUT");
            require(
                players[1].shifterHash == programOutput[0],
                "INVALID_PROGRAM_OUTPUT 0"
            );
            require(
                players[1].shipHashLocation == programOutput[1],
                "INVALID_PROGRAM_OUTPUT 1"
            );
        }
    }
}
