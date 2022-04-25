//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract starkShip {

    Player[2] players;
    //address[] playerAddresses; 
    uint256 public counter;
    uint8 public currentPlayer;
    uint8 public numOfPlayers;
    //hashes 
    uint256 shifter;
    uint256 locShip;
    uint256 programhash;

    struct Player {
        address addr;
        uint shipPosition;
        uint shifter;
        bool turn;  
    }

    enum State {Initial, Started, Finished, Winner}
    State public state;


    constructor(uint256 shipHashLocation, uint256 shifterHash, uint256 programhash) {
        Player memory playerA = Player (msg.sender, shipHashLocation, shifterHash, false);
        players[0] = playerA;
        programhash = programhash;
        state = State.Initial;

    }

    function playerJoins (address _addr, uint256 shipHashLocation, uint256 shifterHash, bool _turn) public {
        require(state == State.Initial);
        Player memory playerB =  Player(msg.sender, shipHashLocation, shifterHash, true) ;
        players[1] = playerB;
        state = State.Started;
    } 
//     mapping (address => int8[]) shotsPlayer ; 
//     mapping (uint =>  mapping(address => uint8[])) positionShot; // Holds the position of the shot in the grid for a player for a current turn. 
//     //mapping (uint => mapping(address => uint8)) lastPositionShot; //Holds the index of the last fired position.
//     //mapping (uint => mapping(address => ShipPosition[])) correctPositionsHit;   //Position of the correct position -> winner 
//     //mapping ()
//     //mapping (address => int8[]) shotsPlayer2 ;



//     uint[] shots = [1,2];

//     function makeShot(address _player, uint8 _shot) public view returns(uint8[] memory){
//         require(state == State.Started);

//         //_shot.push([shotsPlayer2[_player]); 
//         shots.push(_shot);
//         counter += 1 ;

//         return shots ;
//     }

    

//     //Get new grid based on the last shot mapping 
//     function updateGrid() public view returns (uint8){}

//     //position of the last attacked position 

//     function getLastPositionAttacked(address _player, uint256 _counter) public view returns (uint8){}
        

// }







