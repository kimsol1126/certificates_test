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
        if(addressToInfo[addr].addr == 0){
            return false;
        }
        return true;
    }
    
    function setTime() public{
        notBefore = now;
        notAfter = notBefore + 1 years;
    }
    
    function newUserInfo(string name, string birth) public{
        addressToInfo[addr].addr = msg.sender;
        addressToInfo[addr].name = name;
        addressToInfo[addr].birth = birth;
        addressToInfo[addr].notBefore = notBefore;
        addressToInfo[addr].notAfter = notAfter;
        addressToInfo[addr].id = setId();
        
        certhash = keccak256(addressToInfo[addr]);
    }
    
    function setId() public returns(bytes32){
        return keccak256(now, msg.sender);
    }
    
    function newCert() public{
        certificates[addr].caPubkey = "0x19dec5DE28cD9433d73A5FEA9C9D99E137064B57";
        certificates[addr].userPubkey = addr;
        certificates[addr].certhash = certhash;
    }
    
    function getCertificate() public view returns(address, string, string, uint, uint){
        return(newUserInfo[addr].addr, newUserInfo[addr].name, newUserInfo[addr].birth, newUserInfo[addr].notBefore, newUserInfo[addr].notAfter);
    }
}
