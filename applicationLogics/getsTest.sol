contract Simple {
	// 어떤 형태의 function이 React Native에서 값을 받을수 있는지 테스트한다.

    uint storedData;

    function set(uint x) {
        storedData = x;
    }

    function get() constant returns (uint) {
        return storedData;
    }
}