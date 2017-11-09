	/* 
		1. 테스트 명 : React Native에서 mapping 안의 array 값 가져오기
		2. debugger-ui : (2) [BigNumber, "jiho"]
			
		3. React Native : 
				console.log(result);
        console.log(result[0].c[0]);
        console.log(result[1]);
		4. 알게된 점 : 
	*/
	
pragma solidity ^0.4.0;
contract ArrayStru {

    struct User {
        uint idNum;
        string name;
    }
    
    mapping(uint => User[]) public users;
    // covers[] public users;

    function addUser(uint _idNum, string _name) public returns(uint) {
        users[0].push(User(_idNum,_name));

        // users[0][0].idNum = _idNum;
        // users[0][0].name = _name;
        
        return 22;
    }

    function getUsersCount() public constant returns(uint) {
        return 22;
    }

    function getUser(uint index) public constant returns(uint, string) {
        return (users[0][index].idNum, users[0][index].name);
    }
}

