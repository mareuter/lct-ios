//
//  MoonInfoPageViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/24/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class MoonInfoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private struct Constants {
        static let topLevelStoryBoard = "Main"
        static let ephemerisVcName = "EphemerisViewController"
        static let nextFourPhasesVcName = "NextFourPhasesViewController"
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newMoonInfoViewController(Constants.ephemerisVcName),
                self.newMoonInfoViewController(Constants.nextFourPhasesVcName)]
    }()
    
    private func newMoonInfoViewController(_ identifier: String) -> UIViewController {
        return UIStoryboard(name: Constants.topLevelStoryBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad() {
        print ("In viewDidLoad")
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            navigationItem.title = firstViewController.title ?? ""
        }
    }
    
    internal func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController)
        -> UIViewController? {
            print("In pvc before")
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return orderedViewControllers.first
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }

            return orderedViewControllers[previousIndex]
    }
    
    internal func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController)
        -> UIViewController? {
            print("In pvc after")
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return orderedViewControllers.first
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }

            return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        navigationItem.title = self.viewControllers?.first?.title
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.green
        appearance.currentPageIndicatorTintColor = UIColor.red
        appearance.backgroundColor = UIColor.yellow
    }
    
    internal func presentationCount(for pageViewController: UIPageViewController) -> Int {
        //setupPageControl()
        return orderedViewControllers.count
    }
    
    internal func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
