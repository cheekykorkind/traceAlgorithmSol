contract Simple {
	// 간단한 getter setter
	// 깃허브는 commit 하고 push해야 remote repo에 반영된다.
    struct Voter { // Struct
        string a;
        uint b;
    }
		
    mapping(uint => Voter) public voters;
    uint counter;	//	0으로 초기화 된다.
    
    function arithmetics(string _a, uint _b) payable returns (string o_sum, uint o_product) {
        voters[counter++] = Voter(_a, _b);
        o_sum = _a;
        o_product = _b;
    }
    function getVoter(uint a) returns(string r_name, uint r_num){
        r_name = voters[a].a;
        r_num = voters[a].b;
    }
}