//
//  SearchImagePresenterTests.swift
//  PixabayPhotoViewer-MVPTests
//
//  Created by home on 2022/01/31.
//

import XCTest
@testable import PixabayPhotoViewer_MVP

class SearchImagePresenterOutputSpy: SearchImagePresenterOutput {
    private(set) var countOfInvokingUpdateImages: Int = 0
    private(set) var countOfInvokingTransitionToImageDetail: Int = 0
    
    var updateImagesCalledWithImages: (([Image]) -> Void)?
    var transitionToImageDetailCalledWithUrl: ((Image) -> Void)?
    
    func updateImages(_ images: [Image]) {
        countOfInvokingUpdateImages += 1
        updateImagesCalledWithImages?(images)
    }
    
    func transitionToImageDetail(image: Image) {
        // 何回も遷移処理が呼ばれていないか確認するため回数をカウントしてチェック
        countOfInvokingTransitionToImageDetail += 1
        transitionToImageDetailCalledWithUrl?(image)
    }
}

class SearchImageModelInputStub: SearchImageModelInput {
    private var fetchImagesResponses: [String: Result<([Image], Pagination), Error>] = [:]
    
    func addFetchImagesResponse(result: Result<([Image], Pagination), Error>,
                                query: String,
                                page: Int) {
        fetchImagesResponses[query] = result
    }
    
    func fetchImage(query: String,
                    page: Int,
                    completion: @escaping (Result<([Image], Pagination), Error>) -> ()) {
        guard let response = fetchImagesResponses[query] else {
            fatalError("fetchImagesResponses not found when query is \(query)")
        }
        switch response {
        case .success(let response):
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

extension SearchImageModelInputStub {
    struct StubError: Swift.Error{}
}

class SearchImagePresenterTests: XCTestCase {
    
    func testDidTapSearchButton() {
        XCTContext.runActivity(named: "検索ボタンタップ時処理") { _ in
            XCTContext.runActivity(named: "画像検索成功時にView更新処理が呼ばれること") { _ in
                let spy = SearchImagePresenterOutputSpy()
                let stub = SearchImageModelInputStub()
                let presenter = SearchImagePresenter(view: spy, model: stub)
                let query = "test"
                let page = 0
                let images = [Image.mock()]
                let next = Pagination.mock()
                stub.addFetchImagesResponse(result: .success((images, next)),
                                            query: query,
                                            page: page)
                
                let exp = XCTestExpectation(description: "searchImages内部で呼ばれるupdateImagesの実行を待つ")
                presenter.searchImages(query: query, page: page)
                spy.updateImagesCalledWithImages = { images in
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(presenter.numberOfImages == 1)
                XCTAssertTrue(spy.countOfInvokingUpdateImages == 1)
            }
            XCTContext.runActivity(named: "画像検索失敗時はView更新処理が呼ばれないこと") { _ in
                let spy = SearchImagePresenterOutputSpy()
                let stub = SearchImageModelInputStub()
                let presenter = SearchImagePresenter(view: spy, model: stub)
                let query = "test"
                let page = 0
                let error = SearchImageModelInputStub.StubError()
                stub.addFetchImagesResponse(result: .failure(error),
                                            query: query,
                                            page: page)
                
                presenter.searchImages(query: query, page: page)
                
                XCTAssertTrue(presenter.numberOfImages == 0)
                XCTAssertTrue(spy.countOfInvokingUpdateImages == 0)
            }
        }
    }
    
    func testDidSelectRow() {
        XCTContext.runActivity(named: "セル選択時処理") { _ in
            XCTContext.runActivity(named: "成功時に画像詳細への遷移処理が呼ばれること") { _ in
                let spy = SearchImagePresenterOutputSpy()
                let stub = SearchImageModelInputStub()
                let presenter = SearchImagePresenter(view: spy, model: stub)
                let query = "test"
                let page = 0
                let images = [Image.mock()]
                let next = Pagination.mock()
                stub.addFetchImagesResponse(result: .success((images, next)),
                                            query: query,
                                            page: page)
                
                // mockの画像情報をpresenterの変数imagesに代入する
                let exp = XCTestExpectation(description: "searchImages内部で呼ばれるupdateImagesの実行を待つ")
                presenter.searchImages(query: query, page: page)
                spy.updateImagesCalledWithImages = { images in
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 1)
                
                XCTAssertTrue(spy.countOfInvokingTransitionToImageDetail == 0)
                presenter.didSelectItem(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToImageDetail == 1)
            }
            XCTContext.runActivity(named: "失敗時に画像詳細への遷移処理が呼ばれないこと") { _ in
                let spy = SearchImagePresenterOutputSpy()
                let stub = SearchImageModelInputStub()
                let presenter = SearchImagePresenter(view: spy, model: stub)
                let query = ""
                let page = 0
                let error = SearchImageModelInputStub.StubError()
                stub.addFetchImagesResponse(result: .failure(error),
                                            query: query,
                                            page: page)
                
                presenter.searchImages(query: query, page: page)
                
                XCTAssertTrue(spy.countOfInvokingTransitionToImageDetail == 0)
                presenter.didSelectItem(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(spy.countOfInvokingTransitionToImageDetail == 0)
            }
        }
    }
}
