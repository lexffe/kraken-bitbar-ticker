import Foundation

let baseURL = URL(string: "https://api.kraken.com/0/public/Ticker")!

struct Response: Codable {
    let error: [String]
    let result: [String: Pair]
}

struct Pair: Codable {
    let ask: [String]
    let bid: [String]
    let lastClosed: [String]
    let volume: [String]
    let volumeWeightedAvgPrice: [String]
    let trades: [Int]
    let low: [String]
    let high: [String]
    let opening: String
    
    enum CodingKeys: String, CodingKey {
        case ask = "a"
        case bid = "b"
        case lastClosed = "c"
        case volume = "v"
        case volumeWeightedAvgPrice = "p"
        case trades = "t"
        case low = "l"
        case high = "h"
        case opening = "o"
    }
}

let Currencies: [String: String] = [
    "XXBT": "\u{20bf}",
    "XXLM": "XLM",
    "ZGBP": "£",
    "ZUSD": "$",
    "ZEUR": "€",
    "XETH": "\u{039e}"
]

var comp = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
comp.queryItems = [URLQueryItem(name: "pair", value: "XBTUSD,XBTEUR,XBTGBP,ETHXBT,ETHUSD,ETHGBP,XLMUSD")]

var req = URLRequest(url: comp.url!)
req.addValue("Swift/5.2.2", forHTTPHeaderField: "User-Agent")

let semaphore = DispatchSemaphore(value: 0)
let queue = DispatchQueue.global()

queue.async {
    URLSession(configuration: .default).dataTask(with: req) { (data, _, _) in
        if let data = data {
            let body = try! JSONDecoder().decode(Response.self, from: data)
            for (tickerKey, tickerValue) in body.result {
                let c = tickerValue.lastClosed[0]
                let end = c.index(c.endIndex, offsetBy: -3)
                print("\(Currencies[String(tickerKey.prefix(4))]!)-\(Currencies[String(tickerKey.suffix(4))]!): \(c[c.startIndex..<end])")
            }
        }
        semaphore.signal()
    }.resume()
}

_ = semaphore.wait(timeout: .distantFuture)
