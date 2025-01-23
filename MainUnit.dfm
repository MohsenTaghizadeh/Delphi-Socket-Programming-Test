object Form1: TForm1
  Left = 0
  Top = 0
  ClientHeight = 541
  ClientWidth = 790
  Color = clMenu
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 790
    Height = 541
    ActivePage = TcpServer
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 584
    ExplicitHeight = 361
    object TcpClient: TTabSheet
      Caption = 'TCP Client'
      ExplicitWidth = 576
      ExplicitHeight = 330
      object pnl_Main: TPanel
        Left = 0
        Top = 0
        Width = 782
        Height = 510
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 576
        ExplicitHeight = 330
        object pnl1: TPanel
          Left = 258
          Top = 0
          Width = 524
          Height = 510
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 318
          ExplicitHeight = 330
          object Grp_Client: TGroupBox
            AlignWithMargins = True
            Left = 5
            Top = 0
            Width = 516
            Height = 510
            Margins.Left = 5
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alClient
            Caption = 'Send | Receive'
            TabOrder = 0
            ExplicitWidth = 310
            ExplicitHeight = 330
            object List_Client: TStringGrid
              Left = 2
              Top = 18
              Width = 512
              Height = 490
              Align = alClient
              BorderStyle = bsNone
              ColCount = 3
              RowCount = 2
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
              TabOrder = 0
              ExplicitWidth = 306
              ExplicitHeight = 310
              RowHeights = (
                24
                24)
            end
          end
        end
        object pnl2: TPanel
          Left = 0
          Top = 0
          Width = 258
          Height = 510
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitHeight = 330
          object pnl_TCP: TPanel
            Left = 0
            Top = 0
            Width = 258
            Height = 83
            Align = alTop
            BevelInner = bvRaised
            BevelOuter = bvNone
            TabOrder = 0
            object btn_Connect: TBitBtn
              Left = 4
              Top = 52
              Width = 120
              Height = 25
              Caption = 'Connect'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -16
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btn_ConnectClick
            end
            object btn_Ping: TBitBtn
              Left = 130
              Top = 52
              Width = 120
              Height = 25
              Caption = 'Ping'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = btn_PingClick
            end
            object Edt_IP: TLabeledEdit
              Left = 5
              Top = 22
              Width = 120
              Height = 24
              EditLabel.Width = 16
              EditLabel.Height = 16
              EditLabel.Caption = 'IP:'
              TabOrder = 2
            end
            object Edt_Port: TLabeledEdit
              Left = 130
              Top = 22
              Width = 120
              Height = 24
              EditLabel.Width = 28
              EditLabel.Height = 16
              EditLabel.Caption = 'Port:'
              TabOrder = 3
            end
          end
          object scrlbx_Client: TScrollBox
            Left = 0
            Top = 83
            Width = 258
            Height = 405
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            TabOrder = 1
            OnMouseWheel = scrlbx_ClientMouseWheel
            ExplicitHeight = 225
          end
          object btn_Client_AddText: TBitBtn
            Left = 0
            Top = 488
            Width = 258
            Height = 22
            Align = alBottom
            Caption = 'Add Text'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = btn_Client_AddTextClick
            ExplicitLeft = 1
            ExplicitTop = 314
          end
        end
      end
    end
    object TcpServer: TTabSheet
      Caption = 'TCP Server'
      ImageIndex = 1
      ExplicitWidth = 576
      ExplicitHeight = 330
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 782
        Height = 510
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 576
        ExplicitHeight = 330
        object Panel2: TPanel
          Left = 258
          Top = 0
          Width = 524
          Height = 510
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 318
          ExplicitHeight = 330
          object Grp_Server: TGroupBox
            Left = 0
            Top = 0
            Width = 524
            Height = 510
            Align = alClient
            Caption = 'Send | Receive'
            TabOrder = 0
            ExplicitWidth = 318
            ExplicitHeight = 330
            object List_Server: TStringGrid
              Left = 2
              Top = 18
              Width = 520
              Height = 490
              Align = alClient
              ColCount = 3
              RowCount = 2
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
              TabOrder = 0
              ExplicitWidth = 314
              ExplicitHeight = 310
              RowHeights = (
                24
                24)
            end
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 258
          Height = 510
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitHeight = 330
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 258
            Height = 169
            Align = alTop
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 0
            object btn_Listen: TBitBtn
              Left = 4
              Top = 52
              Width = 246
              Height = 25
              Caption = 'Listen'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -16
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btn_ListenClick
            end
            object Edt_Server_Port: TLabeledEdit
              Left = 4
              Top = 22
              Width = 246
              Height = 24
              EditLabel.Width = 28
              EditLabel.Height = 16
              EditLabel.Caption = 'Port:'
              TabOrder = 1
            end
            object Grp_Server_Clients: TGroupBox
              Left = 0
              Top = 83
              Width = 254
              Height = 82
              Align = alBottom
              Caption = 'Clients '
              TabOrder = 2
            end
          end
          object scrlbx_Server: TScrollBox
            Left = 0
            Top = 169
            Width = 258
            Height = 341
            VertScrollBar.Smooth = True
            VertScrollBar.Tracking = True
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            TabOrder = 1
            OnMouseWheel = scrlbx_ClientMouseWheel
            ExplicitLeft = 6
            ExplicitTop = 54
            ExplicitHeight = 235
            object Btn_Server_AddText: TBitBtn
              Left = 0
              Top = 319
              Width = 258
              Height = 22
              Align = alBottom
              Caption = 'Add Text'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGreen
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btn_Client_AddTextClick
              ExplicitLeft = -4
              ExplicitTop = 180
            end
          end
        end
      end
    end
  end
  object IdIcmpClient: TIdIcmpClient
    Protocol = 1
    ProtocolIPv6 = 58
    IPVersion = Id_IPv4
    Left = 408
    Top = 128
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 334
    Top = 219
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServerSocketListen
    OnThreadStart = ServerSocketThreadStart
    OnThreadEnd = ServerSocketThreadEnd
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 326
    Top = 267
  end
end
