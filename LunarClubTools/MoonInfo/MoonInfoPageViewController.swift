//
//  MoonInfoPageViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/24/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit
import Foundation

class MoonInfoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, FetchableData,
    UIPopoverPresentationControllerDelegate
{
    private var fetchDataDelegate: FetchableData?
    private var urlComp = URLComponents()
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    public var currentTime: Date?
    public var currentLocation: (latitude: Double, longitude: Double)?
    public var isLocationOK: Bool?

    private var moonInfoFile: Data? {
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        do {
            let fileList = try fileManager.contentsOfDirectory(at: dirs[0], includingPropertiesForKeys: nil, options: [])
            for file in fileList {
                if file.absoluteString.contains(MoonInfoConstants.downloadedFile) {
                    do {
                        let iFile = try Data(contentsOf: file)
                        return iFile
                    } catch {
                        let readFileFailAlert = UIAlertController(title: ProgramConstants.jsonReadFailedTitle,
                                                                  message: "Failed to read MoonInfo JSON file.",
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
    
    public var moonInfo : MoonInfo?
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

    private func setupMoonInfoUrl() -> URLComponents {
        urlComp.scheme = ProgramConstants.webServiceScheme
        urlComp.host = ProgramConstants.webServiceUrl
        urlComp.path = MoonInfoConstants.webServicePath
        return urlComp
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newMoonInfoViewController(MoonInfoConstants.ephemerisVcName),
                self.newMoonInfoViewController(MoonInfoConstants.nextFourPhasesVcName),
                self.newMoonInfoViewController(MoonInfoConstants.phaseAndLibrationVcName),
                self.newMoonInfoViewController(MoonInfoConstants.skyPositionVcName)]
    }()
    
    private func newMoonInfoViewController(_ identifier: String) -> UIViewController {
        return UIStoryboard(name: MoonInfoConstants.topLevelStoryBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
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
        
        if moonInfoFile != nil {
            moonInfo = MoonInfo(jsonFile: moonInfoFile!)
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchData()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    internal func fetchData() {
        let tbc = tabBarController as! LunarClubToolsTabBarController
        let tl = tbc.timeAndLocation
        currentTime = tl.getCurrentTime()
        currentLocation = tl.getCoordinates()
        isLocationOK = tl.getLocationStatus()
        var url = setupMoonInfoUrl()
        let dateQuery = URLQueryItem(name: "date", value: String(tl.getTimestamp()))
        let timezoneQuery = URLQueryItem(name: "tz", value: MoonInfoConstants.localTimeZone?.identifier)
        let longitudeQuery = URLQueryItem(name: "lon", value: String(currentLocation!.longitude))
        let latitudeQuery = URLQueryItem(name: "lat", value: String(currentLocation!.latitude))
        url.queryItems = [dateQuery, timezoneQuery, latitudeQuery, longitudeQuery]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: url.url!)
        spinner.startAnimating()
        let task = session.dataTask(with: request) { [weak self] (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                let dirs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                let fileName = dirs[0].appendingPathComponent(MoonInfoConstants.downloadedFile)
                if ((try? data?.write(to: fileName, options: [Data.WritingOptions.atomic])) != nil) {
                    DispatchQueue.main.async {
                        self?.moonInfo = MoonInfo(jsonFile: (self?.moonInfoFile!)!)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let downloadFailedAlert = UIAlertController(title: ProgramConstants.requestFailedTitle,
                                                                message: "MoonInfo web service call failed: \(statusCode)",
                                                                preferredStyle: .alert)
                    downloadFailedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(downloadFailedAlert, animated: true, completion: nil)
                    self?.spinner.stopAnimating()
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
