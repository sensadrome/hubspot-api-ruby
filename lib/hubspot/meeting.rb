require 'hubspot/utils'

module Hubspot
  class Meeting
    #
    # HubSpot Meeting API
    #
    # {https://developers.hubspot.com/docs/api/crm/meetings}
    #
    CREATE_MEETING_PATH    = '/crm/v3/objects/meetings'
    MEETING_PATH           = '/crm/v3/objects/meetings/:meeting_id'
    ASSOCIATE_MEETING_PATH = '/crm/v3/objects/meetings/:meeting_id/associations/Contact/:contact_id/meeting_event_to_contact'

    class << self
      def create!(owner_id, meeting_title, meeting_body, start_date_time, end_date_time)
        body = {
          properties: {
            hs_timestamp: DateTime.now.strftime('%Q'),
            hubspot_owner_id: owner_id,
            hs_meeting_title: meeting_title,
            hs_meeting_body: meeting_body,
            hs_meeting_start_time: start_date_time.is_a?(DateTime) ? start_date_time.strftime('%Q') : start_date_time,
            hs_meeting_end_time: end_date_time.is_a?(DateTime) ? end_date_time.strftime('%Q') : end_date_time,
            hs_meeting_outcome: 'SCHEDULED'
          }
        }
        response = Hubspot::Connection.post_json(CREATE_MEETING_PATH, params: {}, body: body)
        HashWithIndifferentAccess.new(response)
      end

      def destroy!(meeting_id)
        Hubspot::Connection.delete_json(MEETING_PATH, {meeting_id: meeting_id})
      end

      def associate!(meeting_id, contact_id)
        Hubspot::Connection.put_json(ASSOCIATE_MEETING_PATH,
                                     params: {
                                       meeting_id: meeting_id,
                                       contact_id: contact_id
                                     })
      end
    end
  end
end
