//
//  LunarClubPageViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 4/26/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class LunarClubPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, FetchableData,
    UIPopoverPresentationControllerDelegate
{
    static let downloadedFile = "LunarClubInfo.json"

    private var fetchDataDelegate: FetchableData?
    private var urlComp = URLComponents()
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    public var timeAndLocation = TimeAndLocation()

    private var lunarClubInfoFile: Data? {
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            let fileList = try fileManager.contentsOfDirectory(at: dirs[0], includingPropertiesForKeys: nil, options: [])
            //print("A: \(fileList)")
            for file in fileList {
                if file.absoluteString.contains(LunarClubPageViewController.downloadedFile) {
                    do {
                        let iFile = try Data(contentsOf: file)
                        return iFile
                    } catch {
                        let readFileFailAlert = UIAlertController(title: ProgramConstants.jsonReadFailedTitle,
                                                                  message: "Failed to read LunarClubInfo JSON file.",
                                                                  preferredStyle: .actionSheet)
                        self.present(readFileFailAlert, animated: true, completion: nil)
                        //print("Failed to read file.")
                        return nil
                    }
                }
            }
        } catch let error {
            print("\(error)")
            print("Cannot read \(dirs[0].absoluteString)")
            return nil
        }
        
        return nil
    }

    public var lunarClubInfo : LunarClubInfo?
    {
        didSet {
            for viewController in orderedViewControllers {
                if let updatable = viewController as? UIUpdatable {
                    updatable.updateUI()
                }
            }
            spinner.stopAnimating()
        }
    }
    
    private func setupLunarClubUrl() -> URLComponents {
        urlComp.scheme = "https"
        urlComp.host = "lct-web.herokuapp.com"
        urlComp.path = "/lunar_club"
        return urlComp
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newLunarClubViewController(LunarClubConstants.specialVcName)]
    }()
    
    private func newLunarClubViewController(_ identifier: String) -> UIViewController {
        return UIStoryboard(name: ProgramConstants.topLevelStoryBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad() {
        print("LCPVC did load")
        super.viewDidLoad()
        
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        fetchDataDelegate = self
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            navigationItem.title = firstViewController.title ?? ""
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    internal func fetchData() {
        let tbc = tabBarController as! LunarClubToolsTabBarController
        timeAndLocation = tbc.timeAndLocation
        let coords = timeAndLocation.getCoordinates()
        var url = setupLunarClubUrl()
        let dateQuery = URLQueryItem(name: "date", value: String(timeAndLocation.getTimestamp()))
        print("\(dateQuery)")
        let longitudeQuery = URLQueryItem(name: "lon", value: String(coords.longitude))
        let latitudeQuery = URLQueryItem(name: "lat", value: String(coords.latitude))
        url.queryItems = [dateQuery, latitudeQuery, longitudeQuery]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        //print(url.url!)
        let request = URLRequest(url: url.url!)
        spinner.startAnimating()
        let task = session.dataTask(with: request) { [weak self] (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                //print("Downloaded Lunar Club Info")
                let fileManager = FileManager.default
                let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = dirs[0].appendingPathComponent(LunarClubPageViewController.downloadedFile)
                //print("\(dirs)")
                if ((try? data?.write(to: fileName)) != nil) {
                    print("OK")
                    DispatchQueue.main.async {
                        self?.lunarClubInfo = LunarClubInfo(jsonFile: (self?.lunarClubInfoFile!)!)
                    }
                } else {
                    print("Failed to write file.")
                }
            } else {
                DispatchQueue.main.async {
                    let downloadFailedAlert = UIAlertController(title: ProgramConstants.requestFailedTitle,
                                                                message: "LunarClubInfo web service call failed: \(statusCode)",
                        preferredStyle: .actionSheet)
                    self?.present(downloadFailedAlert, animated: true, completion: nil)
                }
                //print("Download failed: \(statusCode)")
            }
        }
        task.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if segue.identifier == ProgramConstants.changeTimeSegue {
            if destinationViewController is ChangeTimeViewController {
                if let popoverPresentationController = segue.destination.popoverPresentationController {
                    popoverPresentationController.delegate = self
                }
            }
        }
    }
    
    internal func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController)
        -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            if previousIndex < 0 {
                return orderedViewControllers.last
            } else {
                return orderedViewControllers.first
            }
            
            //            guard orderedViewControllers.count > previousIndex else {
            //                print("Nil2")
            //                return nil
            //            }
            
            //            return orderedViewControllers[previousIndex]
    }
    
    internal func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController)
        -> UIViewController? {
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
    
    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
        ) -> UIModalPresentationStyle
    {
        if traitCollection.verticalSizeClass == .compact {
            return .none
        } else if traitCollection.horizontalSizeClass == .compact {
            return .overFullScreen
        } else {
            return .none
        }
    }
}