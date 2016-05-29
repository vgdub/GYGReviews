# GYGReviews

## Setup

## [CocoaPods](https://cocoapods.org/)

`$ sudo gem install cocoapods`

Then run `pod install` with CocoaPods 0.36 or newer.

### Dependencies

- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) : Reactive library
- [Argo](https://github.com/thoughtbot/Argo) : Swifty json parsing
- [Curry](https://github.com/thoughtbot/Curry) : Dependency of Argo for allowing syntactical sugar when managing JSON objects


##App Structure
### MVVM

#### Models
- Review - review data model
- Encodable - used for swifty JSON parsing
- Changeset - for managing comparing existing objects

#### Stores

- ReviewStore

#### View Models

- ReviewsViewModel
- AddReviewViewModel

#### Views

- ReviewsViewController
- AddReviewViewController
- ReviewCell - Used auto-layout with VFL to showcase my understanding of VFL & UI in code

## DataStore

### CoreData vs. Not
I originally thought to use CoreData for the local datastore, but decided that for something this simple it was a better to use a less involved solution.

ReviewStore Persistance:

- archiveToDisk() - Stores existing set of reviews to disk
- unarchiveFromDisk() - retrievs existing set of reviews from disk

### Mock API Request & Response

```
GET: https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json?&page=0&rating=0&type=&sortBy=date_of_review&direction=DESC

POST: https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews


POST:
// No reviewId because id should be set on the server and returned in the response with the newly created object.

{
     rating: String,
     title: String,
     message: String,
     author: String,
     date: String
}

Post:Response:
{
     status: true,
     data: [
          {
              review_id: Int,
              rating: String,
              title: String,
              message: String,
              author: String,
              date: String
          }
     ]
}
```

What else would I have done with more time?

- Tests - I would have written them, and on a perfect day first. But I needed to move a bit more quickly to implement the architecture and reactive elements.

- Error Hanlding - I would have handled more errors more gracefully.

- Filtering - I would have added this to the reviews list, but time didn't permit enough time to think about handling it properly.


