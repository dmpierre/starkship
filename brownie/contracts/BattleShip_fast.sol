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
        int256 shipHashLocation;
        int256 shifterHash;
    }

    enum State {
        Initial,
        Started,
        Winner
    }
    State public state;

    mapping(address => bool[64]) public shotsPlayer;
    address public verifierContract =
        0xAB43bA48c9edF4C2C4bB01237348D1D7B28ef168;
    uint256 public turn;
    int256 public waitingShot;

    bytes32 pgHash =
        0x002ed20afb826d12df9ae4b9e54c0bf4acb5ddc8375b7254d0c60619111df54f;

    constructor(int256 shipHashLocation, int256 shifterHash) {
        Player memory playerA = Player(
            msg.sender,
            shipHashLocation,
            shifterHash
        );
        players[0] = playerA;
        state = State.Initial;
    }

    IFactRegistry public verifier = IFactRegistry(verifierContract);

    function playerJoins(int256 shipHashLocation, int256 shifterHash) public {
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

    function waitPlayer(int256 shot) public returns (int256) {
        require(msg.sender == players[turn].addr);
        waitingShot = shot;
        return (waitingShot);
    }

    function makeShot(int256[] memory programOutput) public {
        uint256 indexShot = uint256(programOutput[3]);
        programOutput = updateInput(programOutput);
        require(waitingShot != 0);

        // verifyCombatOutputPlayerAShot(programOutput);
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

    function updateInput(int256[] memory programOutput)
        private
        returns (int256[] memory)
    {
        if (programOutput[1] < 0) {
            programOutput[1] += 2**251 + 17 * 2**192 + 1;
        }
        if (programOutput[0] < 0) {
            programOutput[0] += 2**251 + 17 * 2**192 + 1;
        }
        return (programOutput);
    }

    bytes32 public factBeingChecked;
    bool public isProcessed = false;

    function checkFact(int256[] memory programOutput) public returns (bytes32) {
        programOutput = updateInput(programOutput);
        bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
        bytes32 fact = keccak256(abi.encodePacked(pgHash, outputHash));
        factBeingChecked = fact;
        isProcessed = IFactRegistry(verifierContract).isValid(fact);
        return (fact);
    }

    // function verifyCombatOutputPlayerAShot(int256[] memory programOutput)
    //     public
    // {
    //     bytes32 outputHash = keccak256(abi.encodePacked(programOutput));
    //     bytes32 fact = keccak256(abi.encodePacked(pgHash, outputHash));
    //     require(
    //         IFactRegistry(verifierContract).isValid(fact) == true,
    //         "MISSING_CAIRO_PROOF"
    //     );

    // }
}
