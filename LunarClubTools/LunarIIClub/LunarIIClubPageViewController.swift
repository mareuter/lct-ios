//
//  LunarIIClubPageViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 5/30/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit

class LunarIIClubPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, FetchableData,
    UIPopoverPresentationControllerDelegate
{
    private var fetchDataDelegate: FetchableData?
    private var urlComp = URLComponents()
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    public var currentTime: Date?
    public var currentLocation: (latitude: Double, longitude: Double)?
    
    private var lunarIIClubInfoFile: Data? {
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        do {
            let fileList = try fileManager.contentsOfDirectory(at: dirs[0], includingPropertiesForKeys: nil, options: [])
            for file in fileList {
                if file.absoluteString.contains(LunarIIClubConstants.downloadedFile) {
                    do {
                        let iFile = try Data(contentsOf: file)
                        return iFile
                    } catch {
                        let readFileFailAlert = UIAlertController(title: ProgramConstants.jsonReadFailedTitle,
                                                                  message: "Failed to read \(LunarIIClubConstants.downloadedFile) JSON file.",
                                                                  preferredStyle: .alert)
                        readFileFailAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(readFileFailAlert, animated: true, completion: nil)
                        return nil
                    }
                }
            }
        } catch {
            return nil
        }
        
        return nil
    }
    
    public var lunarIIClubInfo : LunarIIClubInfo?
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
    
    private func setupLunarIIClubUrl() -> URLComponents {
        urlComp.scheme = ProgramConstants.webServiceScheme
        urlComp.host = ProgramConstants.webServiceUrl
        urlComp.path = LunarIIClubConstants.webServicePath
        return urlComp
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newLunarIIClubViewController(LunarIIClubConstants.featuresVcName),
                self.newLunarIIClubViewController(LunarIIClubConstants.landingSitesVcName)]
    }()
    
    private func newLunarIIClubViewController(_ identifier: String) -> UIViewController {
        return UIStoryboard(name: LunarIIClubConstants.topLevelStoryBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad() {
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
        
        if lunarIIClubInfoFile != nil {
            lunarIIClubInfo = LunarIIClubInfo(jsonFile: lunarIIClubInfoFile!)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchData()
//    }
    
    internal func fetchData() {
        let tbc = tabBarController as! LunarClubToolsTabBarController
        let tl = tbc.timeAndLocation
        currentTime = tl.getCurrentTime()
        currentLocation = tl.getCoordinates()
        var url = setupLunarIIClubUrl()
        let dateQuery = URLQueryItem(name: "date", value: String(tl.getTimestamp()))
        let longitudeQuery = URLQueryItem(name: "lon", value: String(currentLocation!.longitude))
        let latitudeQuery = URLQueryItem(name: "lat", value: String(currentLocation!.latitude))
        url.queryItems = [dateQuery, latitudeQuery, longitudeQuery]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: url.url!)
        spinner.startAnimating()
        let task = session.dataTask(with: request) { [weak self] (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                let dirs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                let fileName = dirs[0].appendingPathComponent(LunarIIClubConstants.downloadedFile)
                if ((try? data?.write(to: fileName, options: [Data.WritingOptions.atomic])) != nil) {
                    DispatchQueue.main.async {
                        self?.lunarIIClubInfo = LunarIIClubInfo(jsonFile: (self?.lunarIIClubInfoFile!)!)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let downloadFailedAlert = UIAlertController(title: ProgramConstants.requestFailedTitle,
                                                                message: "LunarIIClubInfo web service call failed: \(statusCode)",
                        preferredStyle: .alert)
                    downloadFailedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(downloadFailedAlert, animated: true, completion: nil)
                }
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
                return orderedViewControllers[previousIndex]
            }
    }
    
    internal func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController)
        -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count - 1
            
            if nextIndex > orderedViewControllersCount {
                return orderedViewControllers.first
            } else {
                return orderedViewControllers[nextIndex]
            }
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
