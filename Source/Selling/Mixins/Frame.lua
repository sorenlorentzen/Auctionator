AuctionatorSellingFrameMixin = CreateFromMixins(AuctionatorCommoditySellingMixin, AuctionatorItemSellingMixin)

local AUCTION_DURATIONS = {
  [12] = {
    Duration = 1,
    Text = AUCTION_DURATION_ONE
  },
  [24] = {
    Duration = 2,
    Text = AUCTION_DURATION_TWO
  },
  [48] = {
    Duration = 3,
    Text = AUCTION_DURATION_THREE
  }
}

function AuctionatorSellingFrameMixin:OnLoad()
  Auctionator.Debug.Message("AuctionatorSellingFrameMixin:OnLoad()")

  AuctionatorCommoditySellingMixin.Initialize(self)
  AuctionatorItemSellingMixin.Initialize(self)
end

function AuctionatorSellingFrameMixin:OnShow()
  Auctionator.Debug.Message("AuctionatorSellingFrameMixin:OnShow()")
end

function AuctionatorSellingFrameMixin:SetDuration(dropdown, duration)
  ToggleDropDownMenu(1, nil, dropdown.DropDown)
  UIDropDownMenu_SetText(dropdown.DropDown, AUCTION_DURATIONS[duration].Text)
  dropdown.DropDown:SetDuration(AUCTION_DURATIONS[duration].Duration)
  ToggleDropDownMenu(1, nil, dropdown.DropDown)
end

function AuctionatorSellingFrameMixin:OnEvent(eventName, ...)
  Auctionator.Debug.Message("AuctionatorSellingFrameMixin:OnEvent()", eventName, ...)

  if eventName == "COMMODITY_SEARCH_RESULTS_UPDATED" then
    self:ProcessCommodityResults(...)
  elseif eventName == "ITEM_SEARCH_RESULTS_UPDATED" then
    self:ProcessItemResults(...)
  end
end

function AuctionatorSellingFrameMixin:UpdateSalesPrice(salesPrice, priceFrame)
  local normalizedPrice = salesPrice

  -- Attempting to post an auction with copper value silently failes
  if normalizedPrice % 100 ~= 0 then
    normalizedPrice = normalizedPrice - (normalizedPrice % 100)
  end

  -- Need to have a price of at least one silver
  if normalizedPrice < 100 then
    normalizedPrice = 100
  end

  priceFrame:SetAmount(normalizedPrice)
end