//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

interface IFactRegistry {
    /*
      Returns true if the given fact was previously registered in the contract.
    */
    function isValid(bytes32 fact) external view returns (bool);
}

contract starkShip {
    Player[2] public players;

    struct Player {
        address addr;
        int shipHashLocation;
        int shifterHash;
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
    uint256 public turn;
    int public waitingShot;
                     
    bytes32 pgHash = 0x002ed20afb826d12df9ae4b9e54c0bf4acb5ddc8375b7254d0c60619111df54f;

    constructor(int shipHashLocation, int shifterHash) {
        Player memory playerA = Player(
            msg.sender,
            shipHashLocation,
            shifterHash
        );
        players[0] = playerA;
        state = State.Initial;
    }

    IFactRegistry public verifier = IFactRegistry(verifierContract);

    function playerJoins(int shipHashLocation, int shifterHash) public {
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

    function waitPlayer(int shot) public returns (int){
        require(msg.sender == players[turn].addr);
        waitingShot = shot;
        return (waitingShot);
    }

    function makeShot(int[] memory programOutput) public {
        uint indexShot = uint (programOutput[3]);
        verifyCombatOutputPlayerAShot(programOutput);
        shotsPlayer[msg.sender][indexShot] = true;
        if (programOutput[2] == 1) {
            state = State.Winner;
            return ();
        }
        if (turn == 1) {
            turn = 0;
        } else {
            turn = 1;
        }
        waitingShot = 0;
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
    function checkFact(int[] memory programOutput) public view returns (bytes32) {
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(
            abi.encodePacked(pgHash, outputHash)
        );
        return (
            fact
        );
    }

    function verifyCombatOutputPlayerAShot(int[] memory programOutput)
        public
    {
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(
            abi.encodePacked(pgHash, outputHash)
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
