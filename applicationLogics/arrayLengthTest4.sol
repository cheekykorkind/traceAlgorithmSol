	/* React Native에서 promise.all을 실행이 목표다.
		1. 테스트 명 : primitive type dynamic array의 length return 받기 테스트
		2. debugger-ui : uint만 length return 가능하다. address, string 안된다.
			
		3. React Native : uint만 length return 가능하다. address, string 안된다.
			
		4. 알게된 점 : uint만 length return 가능하다. address, string, sturct 안된다.
	*/
	
contract ArrayStruct {

    struct User {
        uint idNum;
        string name;
    }

    User[] public users;

    function addUser(uint _idNum, string _name) public returns(uint) {
        users.length++;
        users[users.length-1].idNum = _idNum;
        users[users.length-1].name = _name;
        return users.length;
    }

    function getUsersCount() public constant returns(uint) {
        return users.length;
    }

    function getUser(uint index) public constant returns(uint, string) {
        return (users[index].idNum, users[index].name);
    }
}

