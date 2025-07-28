require "grape"

module Dummy
  class NotesAPI < Grape::API
    resource :notes do
      # In-memory storage for notes
      @@notes = []

      desc "Get all notes"
      get do
        { notes: @@notes }
      end

      desc "Create a note"
      params do
        requires :title, type: String, desc: "Note title"
        requires :content, type: String, desc: "Note content"
      end
      post do
        note = { id: @@notes.size + 1, title: params[:title], content: params[:content] }
        @@notes << note
        { note: note }
      end

      desc "Get a note"
      params do
        requires :id, type: Integer, desc: "Note ID"
      end
      get ":id" do
        note = @@notes.find { |n| n[:id] == params[:id].to_i }
        error!("Note not found", 404) unless note
        { note: note }
      end

      desc "Update a note"
      params do
        requires :id, type: Integer, desc: "Note ID"
        optional :title, type: String, desc: "Note title"
        optional :content, type: String, desc: "Note content"
      end
      put ":id" do
        note = @@notes.find { |n| n[:id] == params[:id].to_i }
        error!("Note not found", 404) unless note

        note[:title] = params[:title] if params[:title]
        note[:content] = params[:content] if params[:content]
        { note: note }
      end

      desc "Delete a note"
      params do
        requires :id, type: Integer, desc: "Note ID"
      end
      delete ":id" do
        note = @@notes.find { |n| n[:id] == params[:id].to_i }
        error!("Note not found", 404) unless note

        @@notes.delete(note)
        { message: "Note deleted" }
      end
    end
  end
end
