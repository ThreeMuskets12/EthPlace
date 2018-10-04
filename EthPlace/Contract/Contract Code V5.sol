pragma solidity ^0.4.22;
//Code written by Noah Page
//Version 5.0
//Decentralized code to allow for the creation of a permanent, r/place or MillionDollarHomePage style collection of pixels
//Pixel Placing is live for one month
//After one month everything gets locked up, and everything becomes permanent
//You can place one pixel every five minutes, and placing a PowerPixel cannot be overwritten unless another PowerPixel overwrites it
//It costs 0.01 ether to activate a regular address to start placing pixels
//Registration fee is to prevent people from scripting a ton of addresses to take over the board
//One PowerPixel is 0.025 ether
//Board is 100x100
//he highest power pixel placer gets 20% of all the funds in contract, in the event of a tie, the first person to reach that number wins
//The highest pixel placer gets 10% of all the funds in the contract, in the event of a tie, the first person to reach that number wins
//0 is light grey
//1 is black
//2 is red
//3 is orange
//4 is yellow
//5 is green
//6 is dark grey
//7 is purple
contract again {
    address Admin; //Creates an address variable called Admin to store the address of the contract deployer
    address Badmin; //Creates an address variable called Badmin to store a temp variable
    uint [100][100] gridV; //Creates a 100x100 2d array called grid V to store the color value of each pixel color
    uint [100][100] gridP; //Creates a 100x100 2d array called gridR to store if a x y coordinate is a power pixel or not
    address[100][100] gridA; //Creates a 100x100 2d array called gridA to store who placed a pixel at that x y coordinate
    uint public PowerPixelFee = 0.025 ether; //Creates a variable to store the price of placing a PowerPixel called PowerPixelFee
    uint StartTime; //Creates a variable called StartTime that stores the time of when the contract is started
    uint public RegistrationFee=0.01 ether; //Creates a variable called RegistrationFee that stores the price of registering a new address
    uint PixelWaitTime = 1 minutes; //Creates a variable called PixelWaitTime that stores the amount of time users have to wait between pixel places
    uint GameLiveTime = 90 days; //Creates a variable called GameLiveTime that keeps track of the amount of time the game stays live for
    bool public Live = false; //Creates a boolean that keeps track of whether the game is live or not
    address MyAddress; //Creates an address variable that keeps track of its own address once the contract is deployed
    address public HighestPixelCountAddress; //The address of the current person with the highest pixel count
    uint public HighestPixelCount = 20; //The number of pixels the highest person has placed
    address public HighestPowerPixelCountAddress; //The address of the current person with the highest power pixel count
    uint public HighestPowerPixelCount = 0; //The number of power pixels the highest person has placed
    uint public RegisteredAddressCounter = 0; //The number of registered addresses playing the game
    mapping ( address => User ) public Users; //Maps the Users object


struct User {
      bool Registered; //Boolean that keeps tract of if they are registered or not
      bool AbleToPlace; //Boolean that keeps tract of if they are able to place or not
      uint NumOfPlacedPixels; //Number of pixels they placed
      uint NumOfPlacedPowerPixels; //Number of PowerPixels they placed
      uint LastPlacement; //Keeps tract of when the last time the user placed a pixel
  }

constructor () public payable{
    Admin = msg.sender; //Sets the admin as the address that deployed the contract
    HighestPixelCountAddress=admin;
    Users[Admin].Registered=true; //The admin is now registered
    Users[Admin].AbleToPlace=true; //The admin is currently able to place pixels
    gridV[2][2]=2;
    gridV[2][3]=2;
    gridV[2][4]=2;
    gridV[2][5]=2;
    gridV[2][6]=2;
    gridV[4][2]=2;
    gridV[4][3]=2;
    gridV[4][4]=2;
    gridV[6][2]=2;
    gridV[6][3]=2;
    gridV[6][4]=2;
    gridV[8][4]=6;
    gridV[8][5]=6;
    gridV[8][6]=6;
    gridV[10][2]=2;
    gridV[10][4]=2;
    gridV[10][5]=2;
    gridV[10][6]=2;
    gridV[11][2]=2;
    gridV[12][2]=2;
    }

function RegisterAddressA (address temp) public payable{
    require(msg.value>=RegistrationFee); //Require that you pay at least the registration fee for the function to succeed
    require(Live==true); //Require that the game be live for the function to succeed
        Users[temp].Registered=true; //This specific user's registered boolean is now true
        Users[temp].AbleToPlace=true; //The user is now able to place a pixel
        RegisteredAddressCounter=RegisteredAddressCounter+1;
        temp.transfer(msg.value-RegistrationFee); //Send any left over ether (If they paid more than exactly the ticket price) back to the sender
}


function ChangeRegistrationFee(uint NewFee) public{
    require(msg.sender==Admin); //Require sender to be admin
    RegistrationFee=NewFee; //Set the RegistrationFee to the NewFee
}

function ChangePowerPixelFee(uint NewFee2) public{
    require(msg.sender==Admin); //Require sender to be admin
    PowerPixelFee=NewFee2; //Set the RegistrationFee to the NewFee
}

function ChangePixelWaitTime(uint NewWaitTime) public{
    require(msg.sender==Admin); //Require sender to be admin
    PixelWaitTime=NewWaitTime; //Set the PixelWaitTime to the NewWaitTime
}

function ChangeGameLiveTime(uint NewGameTime) public{
    require(msg.sender==Admin); //Require sender to be admin
    GameLiveTime=NewGameTime; //Set the GameLiveTime to the NewGameTime
}

function PlacePixel(uint value, uint x, uint y) public returns (uint timeRemaining){ //Accepts a value
    require(Users[msg.sender].Registered==true); //You must be registered
    require(Live==true);//The game must be live
    require(gridP[x][y]!=1);//The spot must not have been taken by a power pixel
    require(value==0 || value==1 || value==2 || value == 3 || value == 4 || value ==5 || value == 6 || value == 7); //value has to be 0 through 7
    require(x>=0); //X has to be greater than or equal to 0
    require(x<=100); //X has to be less than or equal to 100
    require(y>=0); //Y has to be greater than or equal to 0
    require(y<=100); //Y has to be less than or equal to 100
    if(Users[msg.sender].LastPlacement + PixelWaitTime <= now){ //if your last placement plus wait time is still less than the current time, you can place
        Users[msg.sender].AbleToPlace=true;
    }
    if(Users[msg.sender].AbleToPlace==true){//You must be able to place
        Users[msg.sender].AbleToPlace=false; //Now you can't place
        Users[msg.sender].LastPlacement=now; //Your last placement is now set to now
        gridV[x][y]=value; //Fill the value on gridV
        gridA[x][y]=msg.sender; //Fill in the address of the person who placed this pixel
        Users[msg.sender].NumOfPlacedPixels++; //Increase your number of placed pixels by one
        if(Users[msg.sender].NumOfPlacedPixels>HighestPixelCount){ //If your number of placed pixels is higher than the current highest pixel count, then
            HighestPixelCountAddress=msg.sender; //Set your address as the address with the current highest pixel count
            HighestPixelCount=Users[msg.sender].NumOfPlacedPixels; //Set your highest number of pixels placed as the new highest number of pixels placed
        }
        return 0; //Indicates the placement was a success
    }
    else{
        return (Users[msg.sender].LastPlacement + PixelWaitTime) - now; //Return your time remaining
    }
}

function PlacePowerPixel (uint value, uint x, uint y) public payable{ //Accepts a value
    require(msg.value>=PowerPixelFee); //You must send at least the PowerPixelFee
    require(Live==true); //The game must be live
    require(Users[msg.sender].Registered==true);//You must be registered
    require(value==0 || value==1 || value==2 || value == 3 || value == 4 || value ==5 || value == 6 || value == 7); //value has to be 0 through 7
    require(x>=0); //X has to be greater than or equal to 0
    require(x<=100); //X has to be less than or equal to 100
    require(y>=0); //Y has to be greater than or equal to 0
    require(y<=100); //Y has to be less than or equal to 100
        Users[msg.sender].NumOfPlacedPowerPixels++; //Increases your number of placed power pixels
        gridA[x][y]=msg.sender; //Fill in the address of the person who placed this pixel
        gridV[x][y]=value;
        gridP[x][y]=1; //Fill p
        if(Users[msg.sender].NumOfPlacedPowerPixels>HighestPowerPixelCount){ //If your number of placed power pixels is higher than the current highest power pixel count, then
            HighestPowerPixelCountAddress=msg.sender; //Set your address as the address with the current highest power pixel count
            HighestPowerPixelCount=Users[msg.sender].NumOfPlacedPowerPixels; //Set your highest number of power pixels placed as the new highest number of power pixels placed
        }
        address temp = msg.sender; //Set a temp variable equal to the address of the message sender
        temp.transfer(msg.value-PowerPixelFee); //Send any left over ether back to the message sender
}

function CheckGridV(uint x, uint y) public constant returns (uint) {
    require(x>=0); //X has to be greater than or equal to 0
    require(x<=100); //X has to be less than or equal to 100
    require(y>=0); //Y has to be greater than or equal to 0
    require(y<=100); //Y has to be less than or equal to 100
        return gridV[x][y]; //Return the R value at the given x y value
    }

function CheckGridP(uint x, uint y) public constant returns (uint) {
    require(x>=0); //X has to be greater than or equal to 0
    require(x<=100); //X has to be less than or equal to 100
    require(y>=0); //Y has to be greater than or equal to 0
    require(y<=100); //Y has to be less than or equal to 100
        return gridP[x][y]; //Return the P value at the given x y value, 1 means it is a powerpixel square
    }
function CheckGridA(uint x, uint y) public constant returns (address) {
    require(x>=0); //X has to be greater than or equal to 0
    require(x<=100); //X has to be less than or equal to 100
    require(y>=0); //Y has to be greater than or equal to 0
    require(y<=100); //Y has to be less than or equal to 100
        return gridA[x][y]; //Return the P value at the given x y value, 1 means it is a powerpixel square
    }

function AttemptToStart(address start) public returns (bool success){
    if(msg.sender==Admin){ //If you are the admin
        Live=true; //Set Live to true (start the game)
        StartTime=now; //The start time of the game is equal to now
        MyAddress = start; //This is kind of a hack to be honest, but basically the admin sends the contract its own address so that it can read its own balance
        //I'm sure there is a better way to do this
        return true;
    }
    else{
        return false;
    }
}

function AttemptToEnd() public returns (bool success){
    if(StartTime + GameLiveTime <=now && Live==true){ //If it has been 30 days
        Live=false; //Set Live equal to false (End the game)
        Admin.transfer((MyAddress.balance/10)*7); //Send 70% of the balance in the contract to the Admin
        HighestPixelCountAddress.transfer((MyAddress.balance/3)); //Send 1/3 of what is left in the contract (1/3 of the 30% remaining is 10%)
        HighestPowerPixelCountAddress.transfer((MyAddress.balance)); //Send what is left in the contract (20%)
        return true;
    }
    else{
        return false;
    }
}

function () public { //The oh crap something went wrong fuction
 revert();   
}
}
