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
        uint shipPosition;
        uint shifter;
        bool turn;
        mapping(address => uint8[])) shotsHistory;
    }


    enum State {Initial, Started, Finished, Winner}
    State public state;

    mapping (address => uint256[]) shotsPlayer ; //Holds the shots of a specific player ; 

    // history of shots 
    
    mapping(address => uint8[])) positionShot2; // Holds the position of the shot in the grid for a player for a current turn. 

    constructor(uint256 shipHashLocation, uint256 shifterHash, uint256 programhash) {
        Player memory playerA = Player (msg.sender, shipHashLocation, shifterHash, false);
        players[0] = playerA;
        programhash = programhash;
        state = State.Initial;

    }
    
    address public verifierContract = 0xAB43bA48c9edF4C2C4bB01237348D1D7B28ef168;
    
    IFactRegistry public verifier = IFactRegistry(verifierContract);

    function playerJoins (address _addr, uint256 shipHashLocation, uint256 shifterHash, bool _turn) public {
        require(state == State.Initial);
        Player memory playerB =  Player(msg.sender, shipHashLocation, shifterHash, true) ;
        players[1] = playerB;
        state = State.Started;
    } 
   
    function makeShot(address _player, uint256 _shot) public view returns(uint256[] memory){
        require(state == State.Started);
        require(shot is not in Player.shtots)
        positionShot[i][]

        return shotsPlayer[_player] ;
    }

    //Get new grid based on the last shot mapping 
    //function updateGrid() public view returns (uint256[] memory){}

    //position of the last attacked position 

    function getLastPositionAttacked(address _player, uint256 _counter) public view returns (uint8){}
        

}







