object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Teste T'#233'cnico WK'
  ClientHeight = 595
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 65
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 719
    object ButtonPopulaClientes: TButton
      Left = 132
      Top = 6
      Width = 113
      Height = 53
      Caption = 'Popula Clientes'
      TabOrder = 0
      OnClick = ButtonPopulaClientesClick
    end
    object ButtonPopulaProdutos: TButton
      Left = 245
      Top = 6
      Width = 113
      Height = 53
      Caption = 'Popula Produtos'
      TabOrder = 1
      OnClick = ButtonPopulaProdutosClick
    end
    object ButtonClientes: TButton
      Left = 358
      Top = 6
      Width = 113
      Height = 53
      Caption = 'Clientes'
      TabOrder = 2
      OnClick = ButtonClientesClick
    end
    object ButtonProdutos: TButton
      Left = 471
      Top = 6
      Width = 113
      Height = 53
      Caption = 'Produtos'
      TabOrder = 3
      OnClick = ButtonProdutosClick
    end
    object ButtonPedidos: TButton
      Left = 584
      Top = 6
      Width = 113
      Height = 53
      Caption = 'Pedidos'
      TabOrder = 4
      OnClick = ButtonPedidosClick
    end
    object ButtonTelaInicial: TButton
      Left = 17
      Top = 6
      Width = 113
      Height = 53
      Caption = 'Tela Inicial'
      TabOrder = 5
      OnClick = ButtonTelaInicialClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 65
    Width = 1008
    Height = 644
    Align = alTop
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 576
    Width = 1008
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitTop = 398
    ExplicitWidth = 719
  end
end
