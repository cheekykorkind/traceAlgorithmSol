	/* 
		1. 테스트 명 : React Native에서 array 안의 mapping 값 가져오기
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
    struct covers{
        uint a;
        mapping(uint=>User) innerStack;
    }

    covers[] public users;

    function addUser(uint _idNum, string _name) public returns(uint) {
        users.length++;
        users[users.length-1].innerStack[0].idNum = _idNum;
        users[users.length-1].innerStack[0].name = _name;
        
        return users.length;
    }

    function getUsersCount() public constant returns(uint) {
        return users.length;
    }

    function getUser(uint index) public constant returns(uint, string) {
        return (users[0].innerStack[index].idNum, users[0].innerStack[index].name);
    }
}
