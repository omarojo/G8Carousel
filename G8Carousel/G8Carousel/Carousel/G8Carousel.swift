//
//  G8Carousel.swift
//  G8Carousel
//
//  Created by Omar Juarez Ortiz on 2017-05-12.
//  Copyright © 2017 Omar Juarez Ortiz. All rights reserved.
//

import Foundation
import UIKit

class G8Carousel: UIView {

    var allowMultipleSelection = true
    var maximumAllowedItemSelection = 3 //number of allowed items to be selected, ex. no more than 3
    var currentSelectedItems: Array = [G8CarouselItem]() {
        didSet {
            print("G8Carousel >> Current Selected: \(currentSelectedItems)")
        }
    }
    
    
    var collectionView: UICollectionView!
    fileprivate let clearItemsButton = UIButton()
    var clearItemsButtonCallback: (()->())?
    weak var delegate: G8CarouselDelegate?
    
    //DataSource
    var allItems = [G8CarouselItem]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        self.layer.masksToBounds = true
        //Flowlayout
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.itemSize = CGSize(width:58.0, height:58.0)
        flowlayout.minimumLineSpacing = 25;
        flowlayout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude; // so that its only one row
        let leftInset = flowlayout.itemSize.width/2 + flowlayout.minimumLineSpacing
        flowlayout.sectionInset = UIEdgeInsetsMake(0, leftInset, 0, flowlayout.minimumLineSpacing);
        
        //Collectionview
        let cFrameLeftMargin = 5+flowlayout.itemSize.width/2
        let cFrame = CGRect(x: cFrameLeftMargin, y: self.bounds.height-flowlayout.itemSize.height, width: self.bounds.width-cFrameLeftMargin , height: flowlayout.itemSize.height)
        collectionView = UICollectionView.init(frame: cFrame, collectionViewLayout: flowlayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleRightMargin]
        collectionView.autoresizesSubviews = true
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .red
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = flowlayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(G8CarouselItemCell.self, forCellWithReuseIdentifier: "ItemCell")
        
        //Clear Button
        clearItemsButton.setImage(UIImage.init(named: "thumbReset"), for: .normal)
        
        clearItemsButton.frame = CGRect(origin: CGPoint(x:5, y:collectionView.frame.origin.y), size: CGSize(width:flowlayout.itemSize.width, height:flowlayout.itemSize.height))
        clearItemsButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        
        self.addSubview(collectionView)
        self.addSubview(clearItemsButton)
        
    
    }
    
    func clearButtonTapped(sender: UIButton){
        let selectedItems = collectionView.indexPathsForSelectedItems
        if let items = selectedItems{
            for indexPath in items {
                collectionView.deselectItem(at: indexPath, animated:false)
                //            if let cell = followCollectionView.cellForItemAtIndexPath(indexPath) as? FollowCell {
                //                cell.checkImg.hidden = true
                //            }
            }
        }
        
        currentSelectedItems.removeAll()
        clearItemsButtonCallback?()
        self.delegate?.didClearSelections(collectionView: collectionView)
    }

}

extension G8Carousel: UICollectionViewDelegate, UICollectionViewDataSource{

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! G8CarouselItemCell
        cell.imageView.image = allItems[indexPath.row].thumb
        
        
        return cell
    }
    //Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allItems.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if(allowMultipleSelection){
            if(currentSelectedItems.count < maximumAllowedItemSelection){
                return true
            }else { return false}
        }
        return true
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("G8Carousel >> Selected index: \(indexPath.row)")
        
        
        if(allowMultipleSelection == false){ //this is a trick
            let selectedIndexes = collectionView.indexPathsForSelectedItems;
            // Don't deselect our own index path
            if var selectedInd = selectedIndexes{
                if let index = selectedInd.index(of:indexPath) {
                    selectedInd.remove(at: index)
                }
                for iPath in selectedInd {
                    collectionView.deselectItem(at: iPath, animated: true)
                }
            }
            currentSelectedItems.removeAll()
            self.currentSelectedItems.append(allItems[indexPath.item])
        }else{
            
            self.currentSelectedItems.append(allItems[indexPath.item])
        }
        
        
        self.delegate?.didSelectItem(item: allItems[indexPath.item] as G8CarouselItem, collectionView: collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("G8Carousel >> DeSelected index: \(indexPath.row)")
        
        let indexToRemove = currentSelectedItems.index(where: {$0 === allItems[indexPath.item]})
        if indexToRemove != nil {
            currentSelectedItems.remove(at: indexToRemove!)
        }
        
        
        self.delegate?.didDeselectItem(item: allItems[indexPath.item] as G8CarouselItem, collectionView: collectionView)
    }


}
//MARK: G8Carousel Protocol
protocol G8CarouselDelegate: class {
    func didSelectItem(item: G8CarouselItem, collectionView: UICollectionView)
    func didDeselectItem(item: G8CarouselItem, collectionView: UICollectionView)
    func didClearSelections(collectionView: UICollectionView)
}

//MARK: Custom Cell
class G8CarouselItemCell: UICollectionViewCell {
    
    var backTransView = UIView()
    var imageView = UIImageView(image: UIImage(named: "filterThumbPlaceHolder"))
    
    override var isSelected: Bool {
        didSet{
            if(isSelected){
//                self.alpha = 0.5
                UIView.animate(withDuration: 0.3, animations: { 
                    self.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    self.backTransView.backgroundColor = UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
                })
                
            }else{
//                self.alpha = 1.0
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.transform = CGAffineTransform.identity
                    self.backTransView.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
                })
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        backTransView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        
        
        contentView.backgroundColor = .clear
        contentView.addSubview(backTransView)
        backTransView.backgroundColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        backTransView.layer.cornerRadius = backTransView.bounds.width/2
        
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width-4, height: contentView.bounds.height-4)
        imageView.center = contentView.center
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.layer.masksToBounds = true
//        imageView.image = UIImage(named: "filterThumbPlaceHolder")
        backTransView.addSubview(imageView)
    }
}

//MARK: G8CarouselItem
class G8CarouselItem{
    var title: String = "Filter"
    var thumb: UIImage = UIImage(named: "filterThumbPlaceHolder")!
    var id: String?
    

}
