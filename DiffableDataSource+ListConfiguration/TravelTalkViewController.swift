//
//  TravelTalkViewController.swift
//  DiffableDataSource+ListConfiguration
//
//  Created by t2023-m0032 on 7/18/24.
//

import UIKit
import SnapKit

struct ChatList: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let chatting: String
    let date: String
}

class TravelTalkViewController: UIViewController {
    let list = [
        ChatList(name: "Hue", chatting: "왜요?", date: "24.01.12"),
        ChatList(name: "Jack", chatting: "푸시하셨나여?", date: "24.01.12"),
        ChatList(name: "Bran", chatting: "화이팅!", date: "24.01.11"),
        ChatList(name: "Den", chatting: "벌써?", date: "24.01.10"),
        ChatList(name: "내옆자리의앞자리에개발잘하는친구", chatting: "모닝콜 점", date: "24.01.09"),
        ChatList(name: "심심이", chatting: "주말과제라닛", date: "24.01.08")
    ]
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    //<섹션을 구분해 줄 데이터 타입, 셀에 들어가는 데이터 타입>
    var dataSource: UICollectionViewDiffableDataSource<Int,ChatList>!//numberOfItemsInSetion, cellForItemAt의 두가지 역할을 다 갖고 있음
    //실제로 데이터를 넣어주는 과정
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatList>()
        snapshot.appendSections([0])
        snapshot.appendItems(list, toSection: 0)
        dataSource.apply(snapshot)
    }
    func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TRAVEL TALK"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }
    private func configureDataSource() {
        var registration: UICollectionView.CellRegistration<UICollectionViewListCell, ChatList?>!
        registration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            //CollectionView SystemCell
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier?.name
            content.secondaryText = itemIdentifier?.chatting
            content.secondaryTextProperties.font = .systemFont(ofSize: 12)
            content.image = UIImage(named: itemIdentifier!.name)
            content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            content.imageProperties.cornerRadius = 20
            cell.contentConfiguration = content
        })
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}
