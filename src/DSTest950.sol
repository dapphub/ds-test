/// DSTest950.sol -- test base class for use with Dapple

// Copyright 2016  Nexus Development, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// A copy of the License may be obtained at the following URL:
//
//    <https://www.apache.org/licenses/LICENSE-2.0>
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

pragma solidity ^0.4.6;

contract DSTest950 {
    event eventListener          (address target, bool exact);
    event logs                   (bytes);
    event log_bytes32            (bytes32);
    event log_named_address      (bytes32 key, address val);
    event log_named_bytes32      (bytes32 key, bytes32 val);
    event log_named_decimal_int  (bytes32 key, int val, uint decimals);
    event log_named_decimal_uint (bytes32 key, uint val, uint decimals);
    event log_named_int          (bytes32 key, int val);
    event log_named_uint         (bytes32 key, uint val);

    bool public IS_TEST;
    bool public failed;

    function DSTest950() {
        IS_TEST = true;
    }

    function setUp() {
    }

    function fail() internal {
        failed = true;
    }

    function expectEventsExact(address target) {
        eventListener(target, true);
    }

    modifier logs_gas() {
        var startGas = msg.gas;
        _;
        var endGas = msg.gas;
        log_named_uint("gas", startGas - endGas);
    }

    function assert(bool condition) internal {
        if (!condition) {
            log_bytes32("Assertion failed");
            fail();
        }
    }

    function assertEq(address a, address b) internal {
        if (a != b) {
            log_bytes32("Error: Wrong `address' value");
            log_named_address("  Expected", b);
            log_named_address("    Actual", a);
            fail();
        }
    }

    function assertEq32(bytes32 a, bytes32 b) internal {
        assertEq(a, b);
    }

    function assertEq(bytes32 a, bytes32 b) internal {
        if (a != b) {
            log_bytes32("Error: Wrong `bytes32' value");
            log_named_bytes32("  Expected", b);
            log_named_bytes32("    Actual", a);
            fail();
        }
    }

    function assertEqDecimal(int a, int b, uint decimals) internal {
        if (a != b) {
            log_bytes32("Error: Wrong fixed-point decimal");
            log_named_decimal_int("  Expected", b, decimals);
            log_named_decimal_int("    Actual", a, decimals);
            fail();
        }
    }

    function assertEqDecimal(uint a, uint b, uint decimals) internal {
        if (a != b) {
            log_bytes32("Error: Wrong fixed-point decimal");
            log_named_decimal_uint("  Expected", b, decimals);
            log_named_decimal_uint("    Actual", a, decimals);
            fail();
        }
    }

    function assertEq(int a, int b) internal {
        if (a != b) {
            log_bytes32("Error: Wrong `int' value");
            log_named_int("  Expected", b);
            log_named_int("    Actual", a);
            fail();
        }
    }

    function assertEq(uint a, uint b) internal {
        if (a != b) {
            log_bytes32("Error: Wrong `uint' value");
            log_named_uint("  Expected", b);
            log_named_uint("    Actual", a);
            fail();
        }
    }
}

contract DSTest950Proxy {
    address target;

    function DSTest950Proxy(address _target) {
        target = _target;
    }

    function () payable {
        if (!target.call.value(msg.value)(msg.data)) {
            throw;
        }
    }
}
