//
//  CoffeeAPIClient.swift
//
//
//  Created by Kei on 2024/05/24.
//

import Dependencies
import DependenciesMacros
import Entity
import Foundation

@DependencyClient
public struct CoffeeAPIClient {
  public var getCoffeeList: @Sendable () async throws -> [PostItem]
}

extension CoffeeAPIClient: DependencyKey {
  public static let liveValue: Self = {
    return Self(
      getCoffeeList: {
        // TODO: Request
        let items = CoffeeAPIClient().createPostItems()
        return items
//        let mock = (0...10).map {
//          if $0 % 2 == 0 {
//            PostItem.mock(id: "\($0)", type: .cafe)
//          } else {
//            PostItem.mock(id: "\($0)", type: .coffee)
//          }
//        }
//        return mock
      }
    )
  }()
}

extension DependencyValues {
  public var coffeeAPIClient: CoffeeAPIClient {
    get { self[CoffeeAPIClient.self] }
    set { self[CoffeeAPIClient.self] = newValue }
  }
}

extension CoffeeAPIClient {
  public func createPostItems() -> [PostItem] {
      return [
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "coffee_sample",
              type: .coffee,
              title: "ブルーマウンテンコーヒー",
              place: "スターバックス新宿店",
              starCount: 5,
              reviewUserName: "山田太郎",
              discription: "とても香りが良く、コクがあって美味しいコーヒーでした。リピート間違いなしです。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "cafe_sample",
              type: .cafe,
              title: "カフェ・ド・パリ",
              place: "渋谷区神南",
              starCount: 4,
              reviewUserName: "佐藤花子",
              discription: "おしゃれな雰囲気で、スタッフも親切でした。コーヒーも美味しかったです。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "coffee_sample",
              type: .coffee,
              title: "エスプレッソ",
              place: "タリーズコーヒー池袋店",
              starCount: 4,
              reviewUserName: "中村一郎",
              discription: "濃厚でしっかりとした味わい。もう少し量が多ければ完璧です。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "cafe_sample",
              type: .cafe,
              title: "ベーカリーカフェ・パリジェンヌ",
              place: "目黒区青葉台",
              starCount: 3,
              reviewUserName: "高橋美咲",
              discription: "パンが美味しくて、コーヒーもなかなかでしたが、少し騒がしかったです。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "coffee_sample",
              type: .coffee,
              title: "モカ",
              place: "ドトールコーヒーショップ銀座店",
              starCount: 5,
              reviewUserName: "小林二郎",
              discription: "風味が豊かで、酸味と甘味のバランスが絶妙。最高の一杯でした。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "cafe_sample",
              type: .cafe,
              title: "カフェ・ルネサンス",
              place: "港区赤坂",
              starCount: 4,
              reviewUserName: "田中直樹",
              discription: "ゆったりとした時間を過ごせる落ち着いたカフェ。コーヒーも美味しかったです。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "coffee_sample",
              type: .coffee,
              title: "カプチーノ",
              place: "セガフレード・ザネッティ新橋店",
              starCount: 4,
              reviewUserName: "鈴木幸子",
              discription: "クリーミーでふんわりとした泡が最高。味も良く満足です。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "cafe_sample",
              type: .cafe,
              title: "コーヒーハウス・ブルーバード",
              place: "世田谷区三軒茶屋",
              starCount: 3,
              reviewUserName: "伊藤誠",
              discription: "コーヒーは普通ですが、ケーキが美味しかったです。次は別のメニューを試してみたいです。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "coffee_sample",
              type: .coffee,
              title: "アイスラテ",
              place: "ベローチェ神田店",
              starCount: 4,
              reviewUserName: "松本和子",
              discription: "冷たくてさっぱり。夏にぴったりの一杯です。もう少し甘さ控えめでも良いかも。"
          ),
          PostItem(
              id: UUID().uuidString,
              thumanbilImage: URL(string: "https://placehold.jp/150x150.png"),
              thumbnailTitle: "cafe_sample",
              type: .cafe,
              title: "グリーンティーカフェ",
              place: "渋谷区代々木",
              starCount: 2,
              reviewUserName: "加藤翔",
              discription: "店内は綺麗ですが、コーヒーの味が薄く感じました。サービスは良かったです。"
          )
      ]
  }
}
