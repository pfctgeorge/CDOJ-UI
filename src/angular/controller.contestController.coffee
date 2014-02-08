cdoj.controller("ContestController", [
  "$scope", "$rootScope", "$http", "$window", "$modal"
  ($scope, $rootScope, $http, $window, $modal) ->
    $scope.contestId = 0
    $scope.contest =
      title: ""
    $scope.problemList = []
    $scope.currentProblem =
      description: ""
      title: ""
      input: ""
      output: ""
      sampleInput: ""
      sampleOutput: ""
      hint: ""
      source: ""
    $scope.$watch("contestId",
    ->
      contestId = angular.copy($scope.contestId)
      $http.get("/contest/data/#{contestId}").then (response)->
        data = response.data
        if data.result == "success"
          $scope.contest = data.contest
          $scope.problemList = data.problemList
          $rootScope.title = data.contest.title
          if data.problemList.length > 0
            $scope.currentProblem = data.problemList[0]
        else
          $window.alert data.error_msg
    )
    $scope.showProblemTab = ->
      # TODO Dirty code!
      $scope.$$childHead.tabs[1].select()
    $scope.showStatusTab = ->
      # TODO Dirty code!
      $scope.$$childHead.tabs[3].select()
    $scope.chooseProblem = (order)->
      $scope.showProblemTab()
      $scope.currentProblem = _.findWhere($scope.problemList, order: order)
    $scope.openSubmitModal = ->
      $modal.open(
        templateUrl: "submitModal.html"
        controller: "SubmitModalController"
        resolve:
          submitDTO: ->
            codeContent: ""
            problemId: $scope.currentProblem.problemId
            contestId: $scope.contest.contestId
            languageId: 2 #default C++
          title: ->
            "#{$scope.currentProblem.orderCharacter} - #{$scope.currentProblem.title}"
      ).result.then (result)->
        if result == "success"
          $scope.showStatusTab()
])