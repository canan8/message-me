class MessagesController < ApplicationController
  before_action :require_user

  def create
    message = current_user.messages.build(message_params)

    if message.save
      ActionCable.server.broadcast "chatroom_channel",
                                   modified_message: message_render(message)
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def message_render(message)
    render(partial: 'message', locals: {message: message})
    # message partial'inda kullanilan message'a buradaki parameter'i pass eder
  end
end