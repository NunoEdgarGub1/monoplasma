// some kind of "now" (epoch) in seconds, valid-ish block.timestamp
function now() {
    return Number.parseInt(+new Date() / 1000, 10)
}

/**
 * Skips ahead a specified number of seconds by increasing EVM/ganache block timestamp
 * @param seconds to skip ahead
 * @returns {Promise<Number>} the new timestamp after the increase (seconds since start of tests)
 */
function increaseTime(seconds) {
    const id = Date.now()

    return new Promise((resolve, reject) => (
        web3.currentProvider.send({
            jsonrpc: "2.0",
            method: "evm_increaseTime",
            params: [seconds],
            id,
        }, (err1, resp) => (err1 ? reject(err1) :
            web3.currentProvider.send({
                jsonrpc: "2.0",
                method: "evm_mine",
                id: id + 1,
            }, err2 => (err2 ? reject(err2) : resolve(resp.result)))
        ))
    ))
}

module.exports = {
    now,
    increaseTime,
}
