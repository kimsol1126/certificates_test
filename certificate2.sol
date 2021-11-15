pragma solidity ^0.8.0;

contract certificate {
    struct userinfo{
        address addr; //20
        string name; //bytes(u.name).length
        string birth; //bytes(u.birth).length
        uint notBefore; //32
        uint notAfter; //32
        bytes32 id; //32
    }
    struct cert {
        bytes32 certhash;
        address caPubkey;
        address userPubkey;
    }
    
    struct deleteInfo{
        bytes32 certhash;
    }
    
    bytes32 certhash;
    address addr;
    uint notBefore;
    uint notAfter;
    
    constructor() public  {
        addr = msg.sender;
    }
    
    mapping(address => userinfo) public addressToInfo;
    mapping(address => cert) public certificates;
    deleteInfo[] public del;
    
    
    function hasinfo() public returns(bool){
        if(addressToInfo[addr].id == 0 ){
            return false;
        }
        return true;
    }
    
    function setTime() private {
        notBefore = block.timestamp;
        notAfter = notBefore + 365 days;
    }
    
    function newUserInfo(string memory name, string memory birth) private {
        addressToInfo[addr].addr = msg.sender;
        addressToInfo[addr].name = name;
        addressToInfo[addr].birth = birth;
        addressToInfo[addr].notBefore = notBefore;
        addressToInfo[addr].notAfter = notAfter;
        addressToInfo[addr].id = setId();
        
        certhash = keccak256(userinfoToBytes(addressToInfo[addr]));
        //certhash = keccak256(abi.encodePacked(addressToInfo[addr].name));
    }
    
    function userinfoToBytes(userinfo memory u) private returns (bytes memory data){
        uint _size = 116 + bytes(u.name).length + bytes(u.birth).length;
        bytes memory _data = new bytes(_size);
        
        uint counter = 0;
        bytes memory baddr = abi.encodePacked(u.addr);
        bytes memory bBefore = abi.encodePacked(u.notBefore);
        bytes memory bAfter = abi.encodePacked(u.notAfter);
        bytes memory bId = abi.encodePacked(u.id);
        for (uint i = 0; i < 20; i++){
            _data[counter] = bytes(baddr)[i];
            counter++;
        }
        for (uint i = 0; i < bytes(u.name).length; i++){
            _data[counter] = bytes(u.name)[i];
            counter++;
        }
        for (uint i = 0; i < bytes(u.birth).length; i++){
            _data[counter] = bytes(u.birth)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bBefore)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bAfter)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bId)[i];
            counter++;
        }
        
        return _data;
    }
    
    function setId() public view returns(bytes32){
        return keccak256(abi.encodePacked(block.timestamp, msg.sender));
    }
    
    function newCert() private {
        certificates[addr].caPubkey = 0x19dec5DE28cD9433d73A5FEA9C9D99E137064B57;
        certificates[addr].userPubkey = addr;
        certificates[addr].certhash = certhash;
    }
    
    function getCertificate() public view returns(address, string memory, string memory, uint, uint, bytes32){
        return(addressToInfo[addr].addr, addressToInfo[addr].name, addressToInfo[addr].birth, addressToInfo[addr].notBefore, addressToInfo[addr].notAfter, addressToInfo[addr].id);
    }
    
    function getCertInfo() public view returns(bytes32, address, address){
        return(certificates[addr].certhash, certificates[addr].caPubkey, certificates[addr].userPubkey);
    }
    
    function issue(string memory name, string memory birth) public {
        if(hasinfo() == false){
            setTime();
            newUserInfo(name, birth);
            newCert();
        }
    }
    
    function verification2(string memory name, string memory birth, uint nbefore, uint nafter, bytes32 id) public returns(bool){
        uint _size = 116 + bytes(name).length + bytes(birth).length;
        bytes memory _data = new bytes(_size);
        
        uint counter = 0;
        bytes memory baddr = abi.encodePacked(addr);
        bytes memory bBefore = abi.encodePacked(nbefore);
        bytes memory bafter = abi.encodePacked(nafter);
        bytes memory bId = abi.encodePacked(id);
        for (uint i = 0; i < 20; i++){
            _data[counter] = bytes(baddr)[i];
            counter++;
        }
        for (uint i = 0; i < bytes(name).length; i++){
            _data[counter] = bytes(name)[i];
            counter++;
        }
        for (uint i = 0; i < bytes(birth).length; i++){
            _data[counter] = bytes(birth)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bBefore)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bafter)[i];
            counter++;
        }
        for (uint i = 0; i < 32; i++){
            _data[counter] = bytes(bId)[i];
            counter++;
        }
        
        bytes32 verifyHash = keccak256(_data);
        
        if(verifyHash == certificates[addr].certhash){
            return true;
        }
        else{
            return false;
        }
    }
    
    function deleteCert() public {
        del.push(deleteInfo(certhash));
        delete addressToInfo[addr];
        delete certificates[addr];
    }
}
