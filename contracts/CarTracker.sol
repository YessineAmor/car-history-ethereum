pragma solidity >=0.4.21 <0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/drafts/Counters.sol";

contract CarTracker is ERC721Full  {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address owner = msg.sender;
    struct CarManufacturer{
        string name;
        uint foundingDate;
        string additionalInfo;
    }
    address[] carManufacturersAddresses;
    mapping(address => CarManufacturer) public carManufacturers;
    struct Car{
        CarManufacturer carManufcaturer;
        string make;
        string model;
        uint manufacturingDate;
        address owner;
    }
    /* 
    no need to use
    uint[] carIds;
    we can just use _tokenIds for iterating through cars
    */
    mapping(uint => Car) cars;
    modifier ownerOnly{
        require(msg.sender == owner,"Owner only!");
        _;
    }

    modifier manufacturerOnly{
        require(carManufacturers[msg.sender].foundingDate!=0,"You need to be a registered car manufacturer to call this function");
        _;
    }

    modifier carOwnerOnly(uint tokenId){
        require(cars[tokenId].owner == msg.sender,"Only car owner can call this function");
        _;
    }

    constructor() ERC721Full("Car", "CAR") public {
    }

    function addCarManufacturer(address _carManufcaturerAddress, string memory _name,uint _foundingDate,string memory _additionalInfo) public ownerOnly {
        carManufacturersAddresses.push(_carManufcaturerAddress);
        carManufacturers[_carManufcaturerAddress] = CarManufacturer(_name,_foundingDate,_additionalInfo);
    }

    function createCar(address manufacturerAddress, string memory tokenURI,string memory _make,string memory _model,uint _manufacturingDate) 
    public manufacturerOnly returns(uint){
        _tokenIds.increment();
        uint256 newCarId = _tokenIds.current();
        _mint(manufacturerAddress,newCarId);
        _setTokenURI(newCarId,tokenURI);
        cars[newCarId] = Car(carManufacturers[manufacturerAddress],_make,_model,_manufacturingDate,manufacturerAddress);
        return newCarId;
    }

    function transferCarOwnership(address _to,uint256 tokenId) public{
        safeTransferFrom(msg.sender,_to,tokenId);
    }

}