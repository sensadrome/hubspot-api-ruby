require 'hubspot/utils'

module Hubspot
  class Meeting
    #
    # HubSpot Deals API
    #
    # {https://developers.hubspot.com/docs/api/crm/meetings}
    #
    SEARCH_MEETINGS_PATH   = "/crm/v3/objects/meetings/search"
    CREATE_MEETING_PATH    = '/crm/v3/objects/meetings'
    MEETING_PATH           = '/crm/v3/objects/meetings/:meetingId'
    ASSOCIATE_MEETING_PATH = 'crm/v3/objects/meetings/:meeting_id/associations/Contact/:contact_id/:object_type'

    class << self
      def search(owner_ids, start_time_range, end_time_range, sorts, opts = {})
        Hubspot::PagedCollection.new(opts) do |options, offset, limit|
          request = {
            "limit" => limit,
            "requestOptions" => options,
            "offset" => {
              "isPrimary" => true
            },
            "filterGroups": [
              "filters": [
                {
                  "values": owner_ids,
                  "operator": "IN",
                  "propertyName": "hubspot_owner_id"
                },
                {

                  "value": start_time_range,
                  "highValue": end_time_range,
                  "propertyName": "hs_meeting_start_time",
                  "operator": "BETWEEN"
                }
              ]
            ],
            "sorts" sorts
          }.merge(properties_hash)

          response = Hubspot::Connection.post_json(
            SEARCH_MEETINGS_PATH,
            params: {"properties": properties},
            body: request
          )
        end
      end

      def create!(params={})
        response = Hubspot::Connection.post_json(CREATE_MEETING_PATH, params: {}, body: params )
        new(HashWithIndifferentAccess.new(response))
      end

      def destroy!(meeting_id)
        Hubspot::Connection.delete_json(MEETING_PATH, {meeting_id: meeting_id})
        @destroyed = true
      end

      def destroyed?
        !!@destroyed
      end

      def associate!(meeting_id, object_type, object_vid)
        Hubspot::Connection.put_json(ASSOCIATE_MEETING_PATH,
                                     params: {
                                       meeting: meeting,
                                       object_type: object_type,
                                       object_vid: object_vid
                                     })
      end

      private

      def properties_hash
        {"properties": ["hubspot_owner_id", "hs_meeting_title", "hs_meeting_start_time", "hs_meeting_end_time"]}
      end
    end
  end
end
