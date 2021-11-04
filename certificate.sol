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
        
        certhash = keccak256(userinfoToBytes(addressToInfo[addr]));
    }
    
    function userinfoToBytes(userinfo memory u) private returns (bytes memory data){    //userinfo 구조체 내부 값들을 바이트열로 변환하여 연접
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
        
        return _data;   //연접한 바이트열 반환
    }
    
    function setId() public returns(bytes32){   //현재시각+컨트랙트 호출자 정보를 이용한 랜덤 난수 생성
        return keccak256(abi.encodePacked(block.timestamp, msg.sender));
    }
    
    function newCert() public{
        certificates[addr].caPubkey = 0x19dec5DE28cD9433d73A5FEA9C9D99E137064B57;
        certificates[addr].userPubkey = addr;
        certificates[addr].certhash = certhash;
    }
    
    function getCertificate() public view returns(address, string memory, string memory, uint, uint){   //인증서 내부 정보 반환
        return(addressToInfo[addr].addr, addressToInfo[addr].name, addressToInfo[addr].birth, addressToInfo[addr].notBefore, addressToInfo[addr].notAfter);
    }
    
    function getCertInfo() public view returns(bytes32, address, address){  //인증서 해시, 이용자 공개키, 발급기관 공개키 반환
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
