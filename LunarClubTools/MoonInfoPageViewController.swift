//
//  MoonInfoPageViewController.swift
//  LunarClubTools
//
//  Created by Michael Reuter on 3/24/17.
//  Copyright © 2017 Type II Software. All rights reserved.
//

import UIKit
import Foundation

class MoonInfoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, FetchableData {
    
    private struct FileNames {
        static let bundleFile = "MoonInfoJSON"
        static let downloadedFile = "MoonInfo.json"
    }
    
    private var fetchDataDelegate: FetchableData?
    private var urlComp = URLComponents()
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    public var timeAndLocation = TimeAndLocation()

    private var moonInfoFile: Data? {
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            let fileList = try fileManager.contentsOfDirectory(at: dirs[0], includingPropertiesForKeys: nil, options: [])
            print("A: \(fileList)")
            for file in fileList {
                if file.absoluteString.contains(FileNames.downloadedFile) {
                    do {
                        let iFile = try Data(contentsOf: file)
                        return iFile
                    } catch {
                        print("Failed to read file.")
                        return nil
                    }
                }
            }
        } catch let error {
            print("\(error)")
            print("Cannot read \(dirs[0].absoluteString)")
            return nil
        }
        
        return NSDataAsset(name: FileNames.bundleFile, bundle: Bundle.main)!.data
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
        urlComp.scheme = "https"
        urlComp.host = "lct-web.herokuapp.com"
        urlComp.path = "/moon_info"
        return urlComp
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newMoonInfoViewController(MoonInfoConstants.ephemerisVcName),
                self.newMoonInfoViewController(MoonInfoConstants.nextFourPhasesVcName)]
    }()
    
    private func newMoonInfoViewController(_ identifier: String) -> UIViewController {
        return UIStoryboard(name: MoonInfoConstants.topLevelStoryBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad() {
        print ("In viewDidLoad")
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
        print("MIPVC will appear")
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("MIPVC will disappear")
    }
    internal func fetchData() {
        print("Fetching data in MIPVC")
        let tbc = tabBarController as! LunarClubToolsTabBarController
        timeAndLocation = tbc.timeAndLocation
        let coords = timeAndLocation.getCoordinates()
        var url = setupMoonInfoUrl()
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
                //print("Downloaded Moon Info")
                let fileManager = FileManager.default
                let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = dirs[0].appendingPathComponent(FileNames.downloadedFile)
                print("\(dirs)")
                if ((try? data?.write(to: fileName)) != nil) {
                    print("OK")
                    DispatchQueue.main.async {
                        self?.moonInfo = MoonInfo(jsonFile: (self?.moonInfoFile!)!)
                    }
                } else {
                    print("Failed to write file.")
                }
            } else {
                print("Download failed: \(statusCode)")
            }
        }
        task.resume()
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
