require 'crowi/client/model/crowi_model'

# Crowi Page model class
class CrowiPage < CrowiModelBase
  GRANT_PUBLIC     = 1.freeze
  GRANT_RESTRICTED = 2.freeze
  GRANT_SPECIFIED  = 3.freeze
  GRANT_OWNER      = 4.freeze

  STATUS_WIP        = 'wip'.freeze
  STATUS_PUBLISHED  = 'published'.freeze
  STATUS_DELETED    = 'deleted'.freeze
  STATUS_DEPRECATED = 'deprecated'.freeze

  attr_reader :_id, :redirectTo, :updatedAt, :lastUpdateUser,
              :creator, :path, :__v, :revision, :createdAt,
              :commentCount, :seenUsers, :liker, :grantedUsers,
              :grant, :status, :id

  # Constract
  # @param [Hash] params Prameters data show as Hash
  # @todo Except running register method always called parse method.
  def initialize(params = {})
    init_params = {
      _id: '', redirectTo: nil, updatedAt: '', lastUpdateUser: '',
      creator: nil, path: nil, __v: 0, revision: nil, createdAt: '',
      commentCount: 0, seenUsers: [], liker: [], grantedUsers: [],
      grant: 0, status: '', id: ''
    }

    params = init_params.merge(params.map { |k,v| [k.to_sym, v] }.to_h)
    if (params[:_id] == nil || params[:path] == nil || params[:id] == nil)
      raise ArgumentError.new('Parameters _id, path and id are required.')
    end

    # @note Parameters lastUpdateUser and creator have two patterns ID only or Object.
    CrowiModelFactory.instance.register({
      page_updatedAt:      Proc.new { |str| str != nil && DateTime.parse(str) },
      page_lastUpdateUser: Proc.new { |param| param != nil && param.is_a?(String) ? param : CrowiUser.new(param) },
      page_creator:        Proc.new { |param| param != nil && param.is_a?(String) ? param : CrowiUser.new(param) },
      page_createdAt:      Proc.new { |str| str != nil && DateTime.parse(str) },
      page_revision:       Proc.new { |param| param != nil && CrowiPageRevision.new(param) },
    })
    maked_params = {}
    params.each do |k,v|
      maker = CrowiModelFactory.instance.maker('page_' + k.to_s)
      maked_params[k] = maker.call(v)
    rescue ArgumentError # page_lastUpdateUserで発生するエラーへの応急処置
      next
    end
    super(maked_params)
  end

end

