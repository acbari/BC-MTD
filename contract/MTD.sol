// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.0;

contract BC_MTD{
    //data EV
    string public Name;     //Car nick name
    address public Owner;   //Owner's Account 
    uint public EVID;       //ID of the electric vehicle
    string public PK;       //EV's public key

    //Request management
    uint public ctr;                            //Record max counter
    mapping(uint => address) public Req_ID;     //Request_counter: requester account
    mapping(address => string) public SPIN;     //account: secret PIN
    mapping(address => string) public Req_PK;   //account: RSA Public key

    //Reply management
    mapping(uint => string) public Enc_Val;      //Request_counter: secret IP,Port,Seed
    
    //Event management
    event NewRequest(uint indexed counter, address indexed requester, string pin, string pk);
    event NewReply(uint indexed counter, string enc_value);

    constructor(string memory CarNickName, uint ev_id, string memory PK_EV) {
        Owner = msg.sender;
        Name = CarNickName;
        EVID = ev_id;
        PK = PK_EV;
        ctr = 0;
    }
    
    function req_connection(string memory SecretPin, string memory req_PK ) public returns (uint ctr_){
        ctr = ctr + 1;
        Req_ID[ctr] = msg.sender;
        SPIN[msg.sender] = SecretPin;
        Req_PK[msg.sender] = req_PK;
        ctr_ = ctr;
        
        emit NewRequest(ctr, msg.sender, SecretPin, req_PK);
    }

    function rep_connection(uint req_counter, string memory enc_value ) public {
        require(
            msg.sender == Owner,
            "Only owner can grant the connection!"
        );
        require(
            req_counter <= ctr && req_counter > 0,
            "Index out of range"
        );

        Enc_Val[req_counter] = enc_value;
       
        emit NewReply(req_counter, enc_value);
    }
    
    function update_PK(string memory new_PK ) public {
        require(
            msg.sender == Owner,
            "Only owner can modify the public key!"
        );
        PK = new_PK;
    }

}
