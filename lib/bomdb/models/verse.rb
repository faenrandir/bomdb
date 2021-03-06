module BomDB
  module Models
    class Verse
      def initialize(db)
        @db = db
      end

      # Find a verse and return a hash, or nil if not found
      def find(chapter:, verse:, book_name: nil, book_id: nil, heading: false)
        @db[:verses].where(
          book_id:       book_by_name_or_id(book_name, book_id),
          verse_chapter: chapter,
          verse_number:  verse,
          verse_heading: heading ? 0 : nil
        ).first
      end

      # Create a verse and return its verse_id
      def create(chapter:, verse:, book_name: nil, book_id: nil, heading: false, range_id: nil)
        @db[:verses].insert(
          book_id:       book_by_name_or_id(book_name, book_id),
          verse_chapter: chapter,
          verse_number:  verse,
          verse_heading: heading ? 0 : nil,
          verse_range_id: range_id
        )
      end

      # Returns a verse_id after finding or creating the verse
      def find_or_create(chapter:, verse:, book_name: nil, book_id: nil, heading: false, range_id: nil)
        v = find(
          chapter: chapter, verse: verse,
          book_name: book_name, book_id: book_id,
          heading: heading
        )
        (v && v[:verse_id]) || create(
          chapter: chapter, verse: verse,
          book_name: book_name, book_id: book_id,
          heading: heading, range_id: range_id
        )
      end

      protected

      def book_by_name_or_id(book_name, book_id)
        if book_id.nil? and book_name.nil?
          raise ArgumentError, "book_name or book_id is required"
        elsif book_id.nil?
          @db[:books].where(book_name: book_name).first[:book_id]
        else
          book_id
        end
      end
    end
  end
end