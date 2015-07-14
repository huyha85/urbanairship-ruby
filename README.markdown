Urbanairship is a Ruby library for interacting with the [Urban Airship API](http://urbanairship.com).

Installation
============
    gem install urbanairship-ruby

Configuration
=============
```ruby
Urbanairship.application_key = 'application-key'
Urbanairship.application_secret = 'application-secret'
Urbanairship.master_secret = 'master-secret'
Urbanairship.logger = Rails.logger
Urbanairship.request_timeout = 5 # default
```

Usage
=====

Registering a device token
--------------------------
```ruby
Urbanairship.register_device('DEVICE-TOKEN')
```
You can also pass an alias, and a set of tags to device registration.
```ruby
Urbanairship.register_device('DEVICE-TOKEN',
  :alias => 'user-123',
  :tags => ['san-francisco-users']
)
```

Unregistering a device token
----------------------------
```ruby
Urbanairship.unregister_device('DEVICE-TOKEN')
```

Retrieving Device Info
----------------------------
```ruby
Urbanairship.device_info('DEVICE-TOKEN')
```

Sending a push notification
---------------------------
```ruby
notification = {
  :audience => {
      :ios_channel => "9c36e8c7-5a73-47c0-9716-99fd3d4197d5"
  },
  :notification => {
       :alert => "Hello!"
  },
  :device_types => "all"
}

Urbanairship.push(notification) # =>
# {
#     :ok => true,
#     :operation_id => "df6a6b50-9843-0304-d5a5-743f246a4946",
#     :push_ids => [
#         "9d78a53b-b16a-c58f-b78d-181d5e242078",
#     ]
# }
```

Batching push notification sends
--------------------------------
```ruby
notifications = [
  {
    :audience => {
        :ios_channel => "9c36e8c7-5a73-47c0-9716-99fd3d4197d5"
    },
    :notification => {
         :alert => "Hello!"
    },
    :device_types => "all"
  },
  {
    :audience => {
        :android_channel => "b8f9b663-0a3b-cf45-587a-be880946e880"
    },
    :notification => {
         :alert => "Hello!"
    },
    :device_types => "all"
  }
]

Urbanairship.batch_push(notifications)
```

Polling the feedback API
------------------------
The first time you attempt to send a push notification to a device that has uninstalled your app (or has opted-out of notifications), both Apple and Urban Airship will register that token in their feedback API. Urban Airship will prevent further attempted notification sends to that device, but it's a good practice to periodically poll Urban Airship's feedback API and mark those tokens as inactive in your own system as well.

```ruby
# find all device tokens deactivated in the past 24 hours
Urbanairship.feedback(24.hours.ago) # =>
# [
#   {
#     "marked_inactive_on"=>"2011-06-03 22:53:23",
#     "alias"=>nil,
#     "device_token"=>"DEVICE-TOKEN-ONE"
#   },
#   {
#     "marked_inactive_on"=>"2011-06-03 22:53:23",
#     "alias"=>nil,
#     "device_token"=>"DEVICE-TOKEN-TWO"
#   }
# ]
```

Schedule notifications
--------------------------------

### Listing your schedules ###

```ruby
Urbanairship.schedules
Urbanairship.schedule('03ab5ba1-6f8d-415d-baae-5a81cc24fae2')
```

### Creating your schedules ###

```ruby
schedule = {
  :name => "Booyah Sports",
  :schedule => {
    :scheduled_time => "2015-08-01T18:45:00Z"
    },
  :push => {
    :audience => {
      :tag => "spoaaaarts"
    },
    :notification => {
      :alert => "Booyah!"
    },
    :device_types => "all"
  }
}

Urbanairship.create_schedule(schedule) # =>
# {
#   "ok" => true,
#   "operation_id" => "cd9d6390-2a12-11e5-a2b8-90e2ba2901f0",
#   "schedule_urls" => [
#     "https://go.urbanairship.com/api/schedules/03ab5ba1-6f8d-415d-baae-5a81cc24fae2"
#   ],
#   "schedule_ids" => [
#     "03ab5ba1-6f8d-415d-baae-5a81cc24fae2"
#   ],
#   "schedules" => [
#     {
#       "url" => "https://go.urbanairship.com/api/schedules/03ab5ba1-6f8d-415d-baae-5a81cc24fae2",
#       "schedule" => {
#         "scheduled_time" => "2015-08-01T18:45:00"
#       },
#       "name" => "Booyah Sports",
#       "push" => {
#         "audience" => {
#           "tag" => "spoaaaarts"
#         },
#         "device_types" => "all",
#         "notification" => {
#           "alert" => "Booyah!"
#         }
#       },
#       "push_ids" => [
#         "a74db2b6-65f0-465f-82d6-4fa25448b642"
#       ]
#     }
#   ]
# }
```

### Modifying your schedules ###

You can modify an unsent scheduled push if you know its ID

```ruby
schedule = {
  :name => "Booyah Sports",
  :schedule => {
    :scheduled_time => "2015-08-01T18:45:00Z"
    },
  :push => {
    :audience => {
      :tag => "spoaaaarts"
    },
    :notification => {
      :alert => "Booyah!"
    },
    :device_types => "all"
  }
}

Urbanairship.update_schedule('03ab5ba1-6f8d-415d-baae-5a81cc24fae2', schedule)
```


### Deleting your schedules ###

If you know the alias or id of a scheduled push notification then you can delete it from Urban Airship's queue and it will not be delivered.

```ruby
Urbanairship.delete_schedule("123456789")
Urbanairship.delete_schedule(123456789)
Urbanairship.delete_schedule(:alias => "deadbeef")
```

Segments
---------------------------

### Creating a segment ###
``` ruby
Urbanairship.create_segment({
  :display_name => 'segment1',
  :criteria => {:and => [{:tag => 'one'}, {:tag => 'two'}]}
}) # => {}
```

### Listing your segments ###

```ruby
Urbanairship.segments # =>
# {
#   "segments" => [
#     {
#      "id" => "abcd-efgh-ijkl",
#      "display_name" => "segment1",
#      "creation_date" => 1360950614201,
#      "modification_date" => 1360950614201
#     }
#   ]
# }

Urbanairship.segment("abcd-efgh-ijkl") # =>
# {
#  "id" => "abcd-efgh-ijkl",
#  "display_name" => "segment1",
#  "creation_date" => 1360950614201,
#  "modification_date" => 1360950614201
# }
```

### Modifying a segment ###
Note that you must provide both the display name and criteria when updating a segment, even if you are only changing one or the other.
``` ruby
Urbanairship.update_segment('abcd-efgh-ijkl', {
  :display_name => 'segment1',
  :criteria => {:and => [{:tag => 'asdf'}]}
}) # => {}
```

### Deleting a segment ###
```ruby
Urbanairship.delete_segment("abcd-efgh-ijkl") # => {}
```

Getting your device tokens
-------------------------------------
```ruby
Urbanairship.device_tokens # =>
# {
#   "device_tokens" => {"device_token"=>"<token>", "active"=>true, "alias"=>"<alias>", "tags"=>[]},
#   "device_tokens_count" => 3,
#   "active_device_tokens_count" => 1
# }
```

Getting a count of your device tokens
-------------------------------------
```ruby
Urbanairship.device_tokens_count # =>
# {
#   "device_tokens_count" => 3,
#   "active_device_tokens_count" => 1
# }
```

Tags
----

Urban Airship allows you to create tags and associate them with devices. Then you can easily send a notification to every device matching a certain tag with a single call to the push API.

### Creating a tag ###

Tags must be registered before you can use them.

```ruby
Urbanairship.add_tag('TAG')
```

### Listing your tags ###

```ruby
Urbanairship.tags
```

### Removing a tag ##

This will remove a tag from your set of registered tags, as well as removing that tag from any devices that are currently using it.

```ruby
Urbanairship.remove_tag('TAG')
```

### View tags associated with device ###

```ruby
Urbanairship.tags_for_device('DEVICE-TOKEN')
```

### Tag a device ###

```ruby
Urbanairship.tag_device(:device_token => 'DEVICE-TOKEN', :tag => 'TAG')
```

You can also tag a device during device registration.

```ruby
Urbanairship.register_device('DEVICE-TOKEN', :tags => ['san-francisco-users'])
```

### Untag a device ###

```ruby
Urbanairship.untag_device(:device_token => 'DEVICE-TOKEN', :tag => 'TAG')
```

### Sending a notification to all devices with a given tag ###

```ruby
notification = {
  :tags => ['san-francisco-users'],
  :aps => {:alert => 'Good morning San Francisco!', :badge => 1}
}

Urbanairship.push(notification)
```

Using Urbanairship with Android
-------------------------------

The Urban Airship API extends a subset of their push API to Android devices. You can read more about what is currently supported [here](https://docs.urbanairship.com/display/DOCS/Server%3A+Android+Push+API), but as of this writing, only registration, aliases, tags, broadcast, individual push, and batch push are supported.

To use this library with Android devices, you can set the `provider` configuration option to `:android`:

```ruby
Urbanairship.provider = :android
```

Alternatively, you can pass the `:provider => :android` option to device registration calls if your app uses Urbanairship to send notifications to both Android and iOS devices.

```ruby
Urbanairship.register_device("DEVICE-TOKEN", :provider => :android)
```

Note: all other supported actions use the same API endpoints as iOS, so it is not necessary to specify the provider as `:android` when calling them.

-----------------------------

Note: all public library methods will return either an array or a hash, depending on the response from the Urban Airship API. In addition, you can inspect these objects to find out if they were successful or not, and what the http response code from Urban Airship was.

```ruby
response = Urbanairship.push(payload)
response.success? # => true
response.code # => '200'
response.inspect # => "{\"scheduled_notifications\"=>[\"https://go.urbanairship.com/api/push/scheduled/123456\"]}"
```

If the call to Urban Airship times out, you'll get a response object with a '503' code.

```ruby
response = Urbanairship.feedback(1.year.ago)
response.success? # => false
response.code # => '503'
response.inspect # => "{\"error\"=>\"Request timeout\"}"
```

Instantiating an Urbanairship::Client
-------------------------------------

Anything you can do directly with the Urbanairship module, you can also do with a Client.

```ruby
client = Urbanairship::Client.new
client.application_key = 'application-key'
client.application_secret = 'application-secret'
client.register_device('DEVICE-TOKEN')
```

This can be used to use clients for different Urbanairship applications in a thread-safe manner.
