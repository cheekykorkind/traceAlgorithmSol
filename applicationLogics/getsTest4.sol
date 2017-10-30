	// 어떤 형태의 function이 React Native에서 값을 받을수 있는지 테스트한다.
	// 테스트 명 : function specifier인 constant로 다양한 getter를 테스트한다.
	// 알게된 점 : set하고 get을 너무 빨리 실행하면 값 반영이 안된다. 이것을 주의하자
	// debugger-ui : BigNumber {s: 1, e: 1, c: Array(1)}
	// React Native : result.c[0] == 11
	
contract Simple {
    
    struct dataStruct { // Struct
        uint _num;
    }
    mapping(uint => dataStruct) public dataStructs;
		
    function set(uint x) {
        // dataStructs.push(dataStruct(x));
        dataStructs[0] = dataStruct(x);
    }

    function getNoParamNoReturnValue() constant returns (uint) {	//	BigNumber {s: 1, e: 1, c: Array(1)}이고 result.c[0] == 11.
        return dataStructs[0]._num;
    }
		function getNoParamReturnValue() constant returns (uint r_x) {	//	BigNumber {s: 1, e: 1, c: Array(1)}이고 result.c[0] == 11.
        r_x =  dataStructs[0]._num;
    }
		function getParamNoReturnValue(uint x) constant returns (uint) {	//	BigNumber {s: 1, e: 1, c: Array(1)}이고 result.c[0] == 11.
        return dataStructs[x]._num;
    }
		function getParamReturnValue(uint x) constant returns (uint r_x) {	//	BigNumber {s: 1, e: 1, c: Array(1)}이고 result.c[0] == 11.
        r_x = dataStructs[x]._num;
    }

}

