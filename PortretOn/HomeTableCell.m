//
//  HomeTableCell.m
//  PortretOn
//
//  Created by Pavel Bochilo on 30.06.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "HomeTableCell.h"

@implementation HomeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)downloadImageWithIndex:(NSDictionary *)urlsDict {
    [self wrapTextByBethierPath];
    //[self wrapiTextByAttributedString];
    NSString *urlString = urlsDict[@"url"];
    [_loadingIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cellImageView.image = [UIImage imageWithData: data];
            [_loadingIndicator stopAnimating];
        });
    });
}

//Method with Attributed String (FOR example textView)
- (void)wrapTextByBethierPath {
//    UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
//    _textViewWithImage.textContainer.exclusionPaths = @[imgRect];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString: _textViewWithImage.text];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"like_1.png"];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    [_textViewWithImage setAttributedText:attributedString];
    
    _textViewWithImage.hidden = false;
}

//Method with Attributed String (FOR example label)
- (void)wrapiTextByAttributedString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:
    @"Here is some text that is wrapping around like an image Here is some text that is wrapping around like an image"];    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"like_1.png"];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    [_likeLabel setAttributedText:attributedString];
    _likeLabel.hidden = false;
}

@end
