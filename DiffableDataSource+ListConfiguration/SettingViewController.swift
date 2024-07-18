//
//  SettingViewController.swift
//  DiffableDataSource+ListConfiguration
//
//  Created by t2023-m0032 on 7/18/24.
//

import UIKit
import SnapKit

struct SettingList:Hashable, Identifiable {
    let id = UUID()
    let title: String
    let subTitle: Int
    let image: UIImage
}

class SettingViewController: UIViewController {
    enum Section: CaseIterable {
        case totalSetting
        case privateSetting
        case etcSetting
        
        var lists: [SettingList] {
            switch self {
            case .totalSetting:
                return Self.list[0]
            case .privateSetting:
                return Self.list[1]
            case .etcSetting:
                return Self.list[2]
            }
        }
        static let list = [
            [
            SettingList(title: "공지사항", subTitle: 3, image: UIImage(systemName: "star")!),
            SettingList(title: "실험실", subTitle: 6, image: UIImage(systemName: "person")!),
            SettingList(title: "버전 정보", subTitle: 17, image: UIImage(systemName: "xmark")!)
            ],
            [SettingList(title: "개인/보안", subTitle: 2, image: UIImage(systemName: "heart")!),
            SettingList(title: "알림", subTitle: 9, image: UIImage(systemName: "pencil")!),
            SettingList(title: "채팅", subTitle: 19, image: UIImage(systemName: "folder")!),
            SettingList(title: "멀티프로필", subTitle: 0, image: UIImage(systemName: "paperplane")!)
            ],
            [
            SettingList(title: "고객센터", subTitle: 11, image: UIImage(systemName: "doc")!)
            ]
        ]
        
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    //<섹션을 구분해 줄 데이터 타입, 셀에 들어가는 데이터 타입>
    var dataSource: UICollectionViewDiffableDataSource<Section, SettingList>!//numberOfItemsInSetion, cellForItemAt의 두가지 역할을 다 갖고 있음
    //실제로 데이터를 넣어주는 과정
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SettingList>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(Section.totalSetting.lists, toSection: .totalSetting)
        snapshot.appendItems(Section.privateSetting.lists,  toSection: .privateSetting)
        snapshot.appendItems(Section.etcSetting.lists, toSection: .etcSetting)
        dataSource.apply(snapshot) //reloadata 대신!
    }
    
    func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        //configuration.backgroundColor = .link
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }
    private func configureDataSource() {
        var registration : UICollectionView.CellRegistration<UICollectionViewListCell, SettingList?>!
        registration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            //CollectionView SystemCell
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier?.title
            content.secondaryText = String(itemIdentifier!.subTitle)
            content.image = itemIdentifier?.image
            content.imageProperties.tintColor = .black

            //content.secondaryTextProperties.color = .blue
            cell.contentConfiguration = content

        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}
