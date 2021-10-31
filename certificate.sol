pragma solidity ^0.8.0;

contract certificate {
    struct userinfo{
        address addr;
        string name;
        string birth;
        uint notBefore;
        uint notAfter;
        bytes32 id;
    }
    struct cert {
        bytes32 certhash;
        address caPubkey;
        address userPubkey;
    }
    
    bytes32 certhash;
    address addr;
    uint notBefore;
    uint notAfter;
    
    constructor() public {
        addr = msg.sender;
    }
    
    mapping(address => userinfo) public addressToInfo;
    mapping(address => cert) public certificates;
    
    
    function hasinfo(address addr) public returns(bool){
        if(addressToInfo[addr].id == 0 ){
            return false;
        }
        return true;
    }
    
    function setTime() public{
        notBefore = block.timestamp;
        notAfter = notBefore + 365 days;
    }
    
    function newUserInfo(string memory name, string memory birth) public{
        addressToInfo[addr].addr = msg.sender;
        addressToInfo[addr].name = name;
        addressToInfo[addr].birth = birth;
        addressToInfo[addr].notBefore = notBefore;
        addressToInfo[addr].notAfter = notAfter;
        addressToInfo[addr].id = setId();
        
        certhash = keccak256(abi.encodePacked(addressToInfo[addr].name));
    }
    
    function setId() public returns(bytes32){
        return keccak256(abi.encodePacked(block.timestamp, msg.sender));
    }
    
    function newCert() public{
        certificates[addr].caPubkey = 0x19dec5DE28cD9433d73A5FEA9C9D99E137064B57;
        certificates[addr].userPubkey = addr;
        certificates[addr].certhash = certhash;
    }
    
    function getCertificate() public view returns(address, string memory, string memory, uint, uint){
        return(addressToInfo[addr].addr, addressToInfo[addr].name, addressToInfo[addr].birth, addressToInfo[addr].notBefore, addressToInfo[addr].notAfter);
    }
    
    function getCertInfo() public view returns(bytes32, address, address){
        return(certificates[addr].certhash, certificates[addr].caPubkey, certificates[addr].userPubkey);
    }
    
    function issue(string memory name, string memory birth) public {
        if(hasinfo(addr) == false){
            setTime();
            newUserInfo(name, birth);
            newCert();
        }
    }
}
