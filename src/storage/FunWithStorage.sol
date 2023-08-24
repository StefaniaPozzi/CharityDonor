//SPDX-License-Identifier:MIT

pragma solidity ^0.8.1;

contract FunWithStorage {
    uint256 s_uint256storage;
    bool s_boolStorage;
    uint256[] s_arrayStorage;
    mapping(uint256 => uint256) s_mapStorage;
    uint256 constant constantStorage = 123;
    uint256 immutable i_immutableStorage;

    constructor() {
        s_uint256storage = 10;
        s_boolStorage = true;
        s_arrayStorage.push(9);
        s_mapStorage[0] = 8;
        i_immutableStorage = 4;
    }
}
