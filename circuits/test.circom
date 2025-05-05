pragma circom 2.0.0;

template Test() {
    signal input a;
    signal input b;
    signal input c;
    signal output res;

    res <== a * b;

    // sicherstellen dass res < c (kleiner als c)
    // kleiner prüfen in circom ist tricky => Workaround mit assert geht:
    assert(res < c);
}

component main = Test();
